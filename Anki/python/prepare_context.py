from __future__ import annotations

import argparse
from pathlib import Path

from source_loader import write_source_context


def main() -> None:
    parser = argparse.ArgumentParser(description="Prepare source context JSON from module PDFs.")
    parser.add_argument("--module-path", required=True, help="Path to module directory, e.g. DHBW/sem4/Network")
    parser.add_argument(
        "--out",
        default="",
        help="Output JSON path (default: <module-path>/doc/source_context.json)",
    )
    parser.add_argument(
        "--no-secondary",
        action="store_true",
        help="Do not include top-level module PDF/TeX files as secondary sources.",
    )
    args = parser.parse_args()

    module_path = Path(args.module_path).resolve()
    out_path = Path(args.out).resolve() if args.out else module_path / "doc" / "source_context.json"

    write_source_context(module_path, out_path, include_secondary=not args.no_secondary)
    print(f"Wrote source context: {out_path}")


if __name__ == "__main__":
    main()
