from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

ALLOWED_TYPES = {"basic", "reversed", "qa", "cloze", "calculation"}


class ValidationError(ValueError):
    """Raised when an input object cannot be coerced into a valid schema."""


@dataclass
class SourceRef:
    file: str
    page: int

    @classmethod
    def from_obj(cls, obj: Any, fallback: "SourceRef | None" = None) -> "SourceRef":
        if isinstance(obj, SourceRef):
            return obj
        if not isinstance(obj, dict):
            if fallback is None:
                raise ValidationError("source must be an object")
            return fallback

        file_name = str(obj.get("file", "")).strip()
        page_raw = obj.get("page", 0)
        try:
            page = int(page_raw)
        except (TypeError, ValueError):
            page = 0

        if not file_name or page <= 0:
            if fallback is None:
                raise ValidationError("source.file and source.page are required")
            return fallback
        return cls(file=file_name, page=page)

    def to_dict(self) -> dict[str, Any]:
        return {"file": self.file, "page": self.page}


@dataclass
class CardFields:
    Front: str = ""
    Back: str = ""
    Text: str = ""
    Extra: str = ""

    @classmethod
    def from_obj(cls, obj: Any) -> "CardFields":
        if not isinstance(obj, dict):
            obj = {}
        return cls(
            Front=str(obj.get("Front", "") or "").strip(),
            Back=str(obj.get("Back", "") or "").strip(),
            Text=str(obj.get("Text", "") or "").strip(),
            Extra=str(obj.get("Extra", "") or "").strip(),
        )

    def to_dict(self) -> dict[str, str]:
        return {
            "Front": self.Front,
            "Back": self.Back,
            "Text": self.Text,
            "Extra": self.Extra,
        }


@dataclass
class Card:
    type: str
    modelName: str
    fields: CardFields
    tags: list[str] = field(default_factory=lambda: ["DHBW", "basis"])
    source: SourceRef = field(default_factory=lambda: SourceRef(file="unknown.pdf", page=1))

    @classmethod
    def from_obj(cls, obj: Any, fallback_source: SourceRef) -> "Card":
        if not isinstance(obj, dict):
            raise ValidationError("card must be an object")

        card_type = str(obj.get("type", "")).strip().lower()
        if card_type not in ALLOWED_TYPES:
            raise ValidationError(f"invalid card.type: {card_type}")

        model_name = "Cloze" if card_type == "cloze" else "Basic"
        if str(obj.get("modelName", "")).strip() in {"Basic", "Cloze"}:
            model_name = str(obj.get("modelName", "")).strip()

        fields = CardFields.from_obj(obj.get("fields", {}))
        source = SourceRef.from_obj(obj.get("source", {}), fallback=fallback_source)

        tags = obj.get("tags", ["DHBW", "basis"])
        if not isinstance(tags, list) or not tags:
            tags = ["DHBW", "basis"]
        tags = [str(tag).strip() for tag in tags if str(tag).strip()]
        if not tags:
            tags = ["DHBW", "basis"]

        card = cls(type=card_type, modelName=model_name, fields=fields, tags=tags, source=source)
        card.validate()
        return card

    def validate(self) -> None:
        if self.type == "cloze":
            if not self.fields.Text or "{{c1::" not in self.fields.Text:
                raise ValidationError("cloze cards require fields.Text with at least one {{c1::...}}")
            if self.fields.Front or self.fields.Back:
                raise ValidationError("cloze cards must keep Front and Back empty")
            self.modelName = "Cloze"
            return

        if not self.fields.Front or not self.fields.Back:
            raise ValidationError("basic/reversed/qa/calculation cards require Front and Back")
        self.modelName = "Basic"

    def semantic_key(self) -> str:
        def norm(value: str) -> str:
            return " ".join("".join(ch.lower() if ch.isalnum() else " " for ch in value).split())

        return "|".join(
            [
                self.type,
                norm(self.fields.Front),
                norm(self.fields.Back),
                norm(self.fields.Text),
            ]
        )

    def to_dict(self) -> dict[str, Any]:
        return {
            "type": self.type,
            "modelName": self.modelName,
            "fields": self.fields.to_dict(),
            "tags": self.tags,
            "source": self.source.to_dict(),
        }


@dataclass
class Deck:
    deckName: str
    modulePath: str
    cards: list[Card]

    def to_dict(self) -> dict[str, Any]:
        return {
            "deckName": self.deckName,
            "modulePath": self.modulePath,
            "cards": [card.to_dict() for card in self.cards],
        }
