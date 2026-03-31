from __future__ import annotations

from models import Card


def dedupe_cards(cards: list[Card]) -> list[Card]:
    """Drop semantic duplicates by normalized content signature while keeping order."""
    seen: set[str] = set()
    unique: list[Card] = []
    for card in cards:
        key = card.semantic_key()
        if key in seen:
            continue
        seen.add(key)
        unique.append(card)
    return unique
