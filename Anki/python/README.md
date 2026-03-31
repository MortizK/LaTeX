# Python Scripts for Reusable Anki Pipeline

This folder contains reusable scripts to build importable Anki deck JSON from module sources.

## Files

- `prepare_context.py`: scans sources and writes `source_context.json`.
- `generate_candidates.py`: creates `candidates.json` from `source_context.json`.
- `finalize_deck.py`: validates, dedupes, and writes final deck JSON.
- `models.py`: strict schema + validation for cards and sources.
- `json_utils.py`: robust parser for LLM JSON (also with code fences/free text).
- `source_loader.py`: PDF discovery + text extraction with page numbers.
- `dedupe.py`: semantic-key based duplicate removal.

## 1) Prepare context for LLM/card generation

```powershell
python prepare_context.py --module-path ../DHBW/sem4/Network
```

Default output:

- `<module_path>/doc/source_context.json`

## 2) Generate candidate cards from source context

```powershell
python generate_candidates.py --module-path ../DHBW/sem4/Network
```

Default output:

- `<module_path>/doc/candidates.json`

## 3) Finalize cards from candidate JSON

```powershell
python finalize_deck.py --module-path ../DHBW/sem4/Network --candidates ../DHBW/sem4/Network/doc/candidates.json --deck-name network_anki --target 50 --strict
```

Default output:

- `<workspace_root>/Anki/decks/<module-name>.json`

## Candidate Input Object (important for LLM outputs)

`finalize_deck.py` accepts either:

- a JSON object with key `cards`, or
- a JSON array of cards.

Each card should match this shape:

```json
{
  "type": "basic|reversed|qa|cloze|calculation",
  "modelName": "Basic|Cloze",
  "fields": {
    "Front": "",
    "Back": "",
    "Text": "",
    "Extra": ""
  },
  "tags": ["DHBW", "basis"],
  "source": {
    "file": "sk7tcpip_26.pdf",
    "page": 26
  }
}
```

Validation rules:

- `cloze` requires `fields.Text` with `{{c1::...}}`, and empty `Front`/`Back`.
- Non-cloze cards require non-empty `Front` and `Back`.
- `source.file` and `source.page` are mandatory; invalid/missing values are replaced by fallback source only if coercion is possible.
- Duplicate cards are removed by normalized semantic key.
- With `--strict`, run fails if `< target` after validation + dedupe.
- `--deck-name` is mandatory.

## Notes

- Primary source priority is implemented by scanning `module_path/doc` first.
- Secondary files (`module_path/*.pdf`, `module_path/*.tex`) are included for context only.
- All JSON is written as valid ASCII-safe output (`ensure_ascii=True`).
