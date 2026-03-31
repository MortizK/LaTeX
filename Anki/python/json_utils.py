from __future__ import annotations

import json
from typing import Any


def parse_json_maybe_wrapped(raw_text: str) -> Any:
    """Parse JSON even if an LLM returned markdown code fences or leading/trailing text."""
    text = raw_text.strip()
    if text.startswith("```"):
        lines = text.splitlines()
        if lines and lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].startswith("```"):
            lines = lines[:-1]
        text = "\n".join(lines).strip()

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        # Fallback: slice first JSON object/array from free-form text.
        starts = [idx for idx in (text.find("{"), text.find("[")) if idx >= 0]
        if not starts:
            raise
        start = min(starts)

        end_obj = text.rfind("}")
        end_arr = text.rfind("]")
        end = max(end_obj, end_arr)
        if end < start:
            raise
        return json.loads(text[start : end + 1])
