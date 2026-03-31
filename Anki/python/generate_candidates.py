from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


ALLOWED_TYPES = {"basic", "reversed", "qa", "cloze", "calculation"}

STOPWORDS = {
    "der",
    "die",
    "das",
    "und",
    "oder",
    "mit",
    "von",
    "fuer",
    "auf",
    "ist",
    "sind",
    "ein",
    "eine",
    "einer",
    "eines",
    "einem",
    "zu",
    "im",
    "in",
    "den",
    "dem",
    "des",
    "als",
    "auch",
    "durch",
    "nur",
    "nicht",
    "dass",
    "werden",
    "wird",
}


def _normalize(text: str) -> str:
    return " ".join(re.sub(r"[^a-z0-9]+", " ", text.lower()).split())


def _split_text(text: str) -> list[str]:
    parts = re.split(r"[\.;]\s+|\s+\u2022\s+|\s+-\s+", text)
    out: list[str] = []
    for part in parts:
        cleaned = " ".join(part.split())
        if 45 <= len(cleaned) <= 260:
            out.append(cleaned)
    return out


def _focus_word(sentence: str) -> str | None:
    words = re.findall(r"[A-Za-z\u00c4\u00d6\u00dc\u00e4\u00f6\u00fc\u00df]{5,}", sentence)
    for word in words:
        if word.lower() not in STOPWORDS:
            return word
    return None


def _looks_calculation(sentence: str) -> bool:
    has_digit = any(ch.isdigit() for ch in sentence)
    has_marker = any(marker in sentence for marker in ("%", "ms", "bit", "byte", "kb", "mb", "gb", "hz"))
    return has_digit and has_marker


def _build_non_cloze(
    card_type: str,
    sentence: str,
    source_file: str,
    source_page: int,
    idx: int,
    module_tag: str,
) -> dict[str, Any]:
    stem = " ".join(sentence.split()[:8]).rstrip(":,;.")

    if card_type == "qa":
        front = f"Frage {idx + 1}: Welche Kernaussage nennt die Folie?"
    elif card_type == "reversed":
        front = f"Ordne die Aussage dem Thema zu: '{stem}'"
    elif card_type == "calculation":
        front = f"Welche quantitative Aussage gilt zu '{stem}'?"
    else:
        front = f"Was ist eine zentrale Aussage zu '{stem}'?"

    return {
        "type": card_type,
        "modelName": "Basic",
        "fields": {
            "Front": front,
            "Back": sentence,
            "Text": "",
            "Extra": f"Quelle: {source_file}, Seite {source_page}",
        },
        "tags": ["DHBW", "basis", module_tag],
        "source": {"file": source_file, "page": source_page},
    }


def _build_cloze(sentence: str, source_file: str, source_page: int, module_tag: str) -> dict[str, Any] | None:
    focus = _focus_word(sentence)
    if not focus:
        return None

    pattern = re.compile(rf"\b{re.escape(focus)}\b")
    text = pattern.sub("{{c1::" + focus + "}}", sentence, count=1)
    if "{{c1::" not in text:
        return None

    return {
        "type": "cloze",
        "modelName": "Cloze",
        "fields": {
            "Front": "",
            "Back": "",
            "Text": text,
            "Extra": f"Quelle: {source_file}, Seite {source_page}",
        },
        "tags": ["DHBW", "basis", module_tag],
        "source": {"file": source_file, "page": source_page},
    }


def _pick_type(position: int, sentence: str) -> str:
    pattern = ["basic", "qa", "reversed", "cloze", "calculation"]
    chosen = pattern[position % len(pattern)]
    if chosen == "calculation" and not _looks_calculation(sentence):
        return "basic"
    return chosen


def _module_tag(module_path: Path) -> str:
    return module_path.name or "module"


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate candidate cards from source_context.json.")
    parser.add_argument("--module-path", required=True, help="Path to module directory, e.g. DHBW/sem4/Network")
    parser.add_argument(
        "--context",
        default="",
        help="Input source context path (default: <module-path>/doc/source_context.json)",
    )
    parser.add_argument(
        "--out",
        default="",
        help="Output candidates path (default: <module-path>/doc/candidates.json)",
    )
    parser.add_argument("--max-cards", type=int, default=140, help="Maximum number of candidate cards to write")
    args = parser.parse_args()

    module_path = Path(args.module_path).resolve()
    context_path = Path(args.context).resolve() if args.context else module_path / "doc" / "source_context.json"
    out_path = Path(args.out).resolve() if args.out else module_path / "doc" / "candidates.json"

    payload = json.loads(context_path.read_text(encoding="utf-8"))
    samples = payload.get("pageSamples", [])
    if not isinstance(samples, list):
        raise SystemExit("Invalid source_context.json: pageSamples must be a list")

    module_tag = _module_tag(module_path)
    cards: list[dict[str, Any]] = []
    seen: set[str] = set()

    for row in samples:
        if not isinstance(row, dict):
            continue

        source_file = str(row.get("file", "")).strip()
        source_page_raw = row.get("page", 0)
        try:
            source_page = int(source_page_raw)
        except (TypeError, ValueError):
            source_page = 0
        text = str(row.get("text", "")).strip()

        if not source_file or source_page <= 0 or not text:
            continue

        for sentence in _split_text(text):
            norm = _normalize(sentence)
            if not norm or norm in seen:
                continue
            seen.add(norm)

            card_type = _pick_type(len(cards), sentence)
            if card_type == "cloze":
                card = _build_cloze(sentence, source_file, source_page, module_tag)
                if card is None:
                    card = _build_non_cloze("basic", sentence, source_file, source_page, len(cards), module_tag)
            else:
                if card_type not in ALLOWED_TYPES:
                    card_type = "basic"
                card = _build_non_cloze(card_type, sentence, source_file, source_page, len(cards), module_tag)

            cards.append(card)
            if len(cards) >= args.max_cards:
                break

        if len(cards) >= args.max_cards:
            break

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps({"cards": cards}, ensure_ascii=True, indent=2), encoding="utf-8")

    print(f"Wrote candidates: {out_path}")
    print(f"Candidate cards: {len(cards)}")


if __name__ == "__main__":
    main()