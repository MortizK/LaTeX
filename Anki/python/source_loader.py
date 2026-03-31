from __future__ import annotations

import json
from pathlib import Path
from typing import Any

from pypdf import PdfReader


def list_primary_pdfs(module_path: Path) -> list[Path]:
    doc_dir = module_path / "doc"
    if not doc_dir.exists():
        return []
    return sorted(doc_dir.rglob("*.pdf"))


def list_secondary_files(module_path: Path) -> list[Path]:
    files: list[Path] = []
    for ext in ("*.pdf", "*.tex"):
        files.extend(sorted(module_path.glob(ext)))
    return files


def read_pdf_pages(pdf_path: Path) -> list[dict[str, Any]]:
    pages: list[dict[str, Any]] = []
    reader = PdfReader(str(pdf_path))
    for i, page in enumerate(reader.pages, start=1):
        text = page.extract_text() or ""
        pages.append(
            {
                "file": pdf_path.name,
                "path": str(pdf_path).replace("\\", "/"),
                "page": i,
                "text": " ".join(text.split()),
            }
        )
    return pages


def collect_source_context(module_path: Path, include_secondary: bool = True) -> dict[str, Any]:
    primary = list_primary_pdfs(module_path)
    secondary = list_secondary_files(module_path) if include_secondary else []

    page_samples: list[dict[str, Any]] = []
    for pdf in primary:
        for row in read_pdf_pages(pdf):
            text = row["text"]
            if text:
                row["text"] = text[:1400]
                page_samples.append(row)

    return {
        "modulePath": str(module_path).replace("\\", "/"),
        "primaryPdfFiles": [str(path).replace("\\", "/") for path in primary],
        "secondaryFiles": [str(path).replace("\\", "/") for path in secondary],
        "pageSamples": page_samples,
    }


def write_source_context(module_path: Path, output_path: Path, include_secondary: bool = True) -> None:
    payload = collect_source_context(module_path, include_secondary=include_secondary)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(payload, ensure_ascii=True, indent=2), encoding="utf-8")
