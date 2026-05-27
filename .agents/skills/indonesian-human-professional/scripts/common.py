"""
Shared module for Indonesian Validator scripts.

This module is FULLY IMPLEMENTED by Opus. Flash should NOT modify this file.
It provides:
- Data types (Issue, LayerResult)
- Singleton loaders (Stanza pipeline, PySastrawi stemmer, JSON data)
- Output formatting for CLI and pipeline aggregation
"""

from __future__ import annotations

import json
import sys
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Literal

# ─── Constants ───────────────────────────────────────────────────────────────

SKILL_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = SKILL_ROOT / "data"

Severity = Literal["error", "warning", "info"]
Domain = Literal["bahasa-core", "anti-ai-style", "academic-compliance"]


# ─── Data Types ──────────────────────────────────────────────────────────────

@dataclass
class Issue:
    """A single validation issue found in the text."""
    type: Severity
    message: str
    suggestion: str = ""
    word: str = ""
    line: int = 0
    position: tuple[int, int] = (0, 0)  # (start, end) char span
    rule: str = ""  # e.g. "KBBI-BAKU-001"

    def to_dict(self) -> dict:
        d = asdict(self)
        d["position"] = list(d["position"])
        return d


@dataclass
class LayerResult:
    """Output from a single validation layer."""
    layer: str          # e.g. "L1"
    domain: Domain
    script: str         # e.g. "validate_baku.py"
    issues: list[Issue] = field(default_factory=list)
    stats: dict = field(default_factory=dict)

    def to_dict(self) -> dict:
        return {
            "layer": self.layer,
            "domain": self.domain,
            "script": self.script,
            "issues": [i.to_dict() for i in self.issues],
            "stats": self.stats,
        }

    def to_json(self, indent: int = 2) -> str:
        return json.dumps(self.to_dict(), ensure_ascii=False, indent=indent)


# ─── Singletons ─────────────────────────────────────────────────────────────

_stanza_pipeline = None
_stemmer = None
_data_cache: dict[str, dict | list] = {}


def get_stanza_pipeline():
    """
    Returns a cached Stanza Indonesian pipeline.
    Initializes on first call. Requires: pip install stanza
    First run also needs: stanza.download('id')
    """
    global _stanza_pipeline
    if _stanza_pipeline is None:
        import stanza
        _stanza_pipeline = stanza.Pipeline("id", processors="tokenize,pos,lemma")
    return _stanza_pipeline


def get_stemmer():
    """
    Returns a cached PySastrawi stemmer.
    Requires: pip install PySastrawi
    """
    global _stemmer
    if _stemmer is None:
        from Sastrawi.Stemmer.StemmerFactory import StemmerFactory
        _stemmer = StemmerFactory().create_stemmer()
    return _stemmer


def load_data(filename: str) -> dict | list:
    """
    Load a JSON file from data/ directory. Cached after first load.
    Usage: load_data("baku_tidak_baku.json")
    """
    if filename not in _data_cache:
        path = DATA_DIR / filename
        if not path.exists():
            print(f"[ERROR] Data file not found: {path}", file=sys.stderr)
            sys.exit(1)
        with open(path, "r", encoding="utf-8") as f:
            _data_cache[filename] = json.load(f)
    return _data_cache[filename]


# ─── Output Helpers ──────────────────────────────────────────────────────────

def print_result(result: LayerResult) -> None:
    """Print a LayerResult as formatted JSON to stdout."""
    print(result.to_json())


def print_issues_human(result: LayerResult) -> None:
    """Print issues in a human-readable format (for --verbose mode)."""
    if not result.issues:
        print(f"[{result.layer}] ✓ No issues found.")
        return
    print(f"[{result.layer}] Found {len(result.issues)} issue(s):")
    for issue in result.issues:
        prefix = {"error": "✗", "warning": "⚠", "info": "ℹ"}[issue.type]
        line_info = f" (line {issue.line})" if issue.line else ""
        word_info = f" '{issue.word}'" if issue.word else ""
        suggestion = f" → {issue.suggestion}" if issue.suggestion else ""
        print(f"  {prefix} [{issue.rule}]{line_info}{word_info}: {issue.message}{suggestion}")


# ─── CLI Helpers ─────────────────────────────────────────────────────────────

def read_input(args) -> str:
    """
    Read input text from CLI args or stdin.
    Supports: script.py "inline text"
              script.py input.txt
              echo "text" | script.py
    """
    if hasattr(args, "text") and args.text:
        # Check if it's a file path
        p = Path(args.text)
        if p.exists() and p.is_file():
            return p.read_text(encoding="utf-8")
        return args.text
    elif not sys.stdin.isatty():
        return sys.stdin.read()
    else:
        print("Usage: script.py 'text' or script.py file.txt or echo 'text' | script.py",
              file=sys.stderr)
        sys.exit(1)
