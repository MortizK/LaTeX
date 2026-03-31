from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Any

from dedupe import dedupe_cards
from json_utils import parse_json_maybe_wrapped
from models import Card, Deck, SourceRef, ValidationError
from source_loader import list_primary_pdfs


def _load_candidate_cards(raw: Any) -> list[dict[str, Any]]:
    if isinstance(raw, dict) and isinstance(raw.get("cards"), list):
        return raw["cards"]
    if isinstance(raw, list):
        return raw
    raise ValidationError("Candidates JSON must be either a list of cards or an object with 'cards'.")


def _fallback_source(module_path: Path) -> SourceRef:
    primary = list_primary_pdfs(module_path)
    if primary:
        return SourceRef(file=primary[0].name, page=1)
    return SourceRef(file="unknown.pdf", page=1)


def _default_output_path(module_path: Path) -> Path:
    workspace_root = Path(__file__).resolve().parents[2]
    module_name = module_path.name or "module"
    return workspace_root / "Anki" / "decks" / f"{module_name}.json"


def main() -> None:
    parser = argparse.ArgumentParser(description="Validate, dedupe and finalize Anki flashcards JSON.")
    parser.add_argument("--module-path", required=True, help="Path to module directory, e.g. DHBW/sem4/Network")
    parser.add_argument("--candidates", required=True, help="Path to candidate cards JSON (often LLM output)")
    parser.add_argument("--deck-name", required=True, help="Deck name (required)")
    parser.add_argument("--target", type=int, default=50, help="Exact number of cards required")
    parser.add_argument(
        "--out",
        default="",
        help="Output JSON path (default: <workspace>/Anki/decks/<module-name>.json)",
    )
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Fail if cards are less than target after validation and dedupe (default: truncate only when above target).",
    )
    args = parser.parse_args()

    module_path = Path(args.module_path).resolve()
    output_path = Path(args.out).resolve() if args.out else _default_output_path(module_path)

    raw_text = Path(args.candidates).read_text(encoding="utf-8")
    payload = parse_json_maybe_wrapped(raw_text)
    candidate_cards = _load_candidate_cards(payload)

    fallback_source = _fallback_source(module_path)
    validated: list[Card] = []
    rejected = 0

    for obj in candidate_cards:
        try:
            validated.append(Card.from_obj(obj, fallback_source=fallback_source))
        except ValidationError:
            rejected += 1

    unique_cards = dedupe_cards(validated)

    if len(unique_cards) > args.target:
        unique_cards = unique_cards[: args.target]

    if args.strict and len(unique_cards) < args.target:
        raise SystemExit(
            f"Not enough valid unique cards: {len(unique_cards)} < target {args.target}. Rejected: {rejected}"
        )

    deck = Deck(
        deckName=args.deck_name,
        modulePath=str(module_path).replace("\\", "/"),
        cards=unique_cards,
    )

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(deck.to_dict(), ensure_ascii=True, indent=2), encoding="utf-8")

    print(f"Wrote deck: {output_path}")
    print(f"Cards: {len(unique_cards)} (target: {args.target})")
    print(f"Rejected invalid cards: {rejected}")


if __name__ == "__main__":
    main()
