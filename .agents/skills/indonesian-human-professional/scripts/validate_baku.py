#!/usr/bin/env python3
"""
L1 + L2 + L3: Baku word validation pipeline.

L1: Look up word in baku_tidak_baku.json (direct correction)
L2: Stem with PySastrawi to get root word
L3: Check root against kbbi_roots.json (is it baku?)

Usage:
    python validate_baku.py "Aktifitas menganalisa data"
    python validate_baku.py input.txt
    echo "Aktifitas" | python validate_baku.py
    python validate_baku.py --test
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    Issue, LayerResult, get_stemmer, load_data,
    print_result, print_issues_human, read_input,
)


def check_baku(text: str) -> LayerResult:
    """
    Validate every word in `text` for baku correctness.

    Algorithm:
    1. Tokenize text into words (simple whitespace split, strip punctuation)
    2. For each word:
       a. Check against baku_tidak_baku.json (L1)
          - If found: report error with correction
       b. Stem with PySastrawi to get root (L2)
       c. Check root against kbbi_roots.json (L3)
          - If root NOT in KBBI: report warning (possibly non-standard)
    3. Return LayerResult with all issues

    Data files required:
    - data/baku_tidak_baku.json  →  {"tidak_baku_word": "baku_word", ...}
    - data/kbbi_roots.json       →  ["root1", "root2", ...]  (list of valid roots)
    """
    import re
    result = LayerResult(layer="L1+L2+L3", domain="bahasa-core", script="validate_baku.py")

    # Load data
    baku_map = load_data("baku_tidak_baku.json")
    kbbi_roots = set(load_data("kbbi_roots.json"))
    stemmer = get_stemmer()

    # Simple tokenization: extract words and their positions
    # We use finditer to track start/end positions for Issue reporting
    words_count = 0
    pattern = re.compile(r"\b\w+\b")

    for match in pattern.finditer(text):
        word = match.group()
        start, end = match.span()

        # skip numbers
        if word.isdigit():
            continue

        # skip capitalized proper nouns (simple heuristic)
        if word[0].isupper():
            continue

        word_lower = word.lower()
        words_count += 1

        # 1. L1: Direct correction
        if word_lower in baku_map:
            suggestion = baku_map[word_lower]
            # Match case if possible (simple title case check)
            if word[0].isupper():
                suggestion = suggestion.capitalize()

            result.issues.append(Issue(
                type="error",
                message=f"Kata '{word}' tidak baku. Gunakan '{suggestion}'.",
                suggestion=suggestion,
                word=word,
                position=(start, end),
                rule="L1-BAKU-DIRECT"
            ))
            continue # If found in L1, usually no need to check root further

        # 2. L2: Stemming
        root = stemmer.stem(word_lower)

        # 3. L3: Root validation
        if root not in kbbi_roots:
            # If the root is not in KBBI, it might be non-baku or a foreign word
            # We flag it as a warning (L3)
            result.issues.append(Issue(
                type="warning",
                message=f"Kata dasar '{root}' tidak ditemukan di KBBI. Mungkin tidak baku.",
                suggestion="",
                word=word,
                position=(start, end),
                rule="L3-KBBI-ROOT"
            ))

    result.stats["words_checked"] = words_count
    return result


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="L1+L2+L3: Baku word validation")
    parser.add_argument("text", nargs="?", help="Text to validate or path to file")
    parser.add_argument("--verbose", "-v", action="store_true", help="Human-readable output")
    parser.add_argument("--test", action="store_true", help="Run inline tests")
    args = parser.parse_args()

    if args.test:
        run_tests()
        return

    text = read_input(args)
    result = check_baku(text)

    if args.verbose:
        print_issues_human(result)
    else:
        print_result(result)


# ─── Inline Tests ────────────────────────────────────────────────────────────

def run_tests():
    """
    Pre-written test assertions. Flash must make these pass.
    Run with: python validate_baku.py --test
    """
    print("Running validate_baku tests...")

    # Test 1: Direct baku correction (L1)
    r = check_baku("Aktifitas")
    errors = [i for i in r.issues if i.word.lower() == "aktifitas"]
    assert len(errors) >= 1, "Should flag 'Aktifitas'"
    assert errors[0].suggestion.lower() == "aktivitas", f"Should suggest 'Aktivitas', got '{errors[0].suggestion}'"

    # Test 2: Root word correction (L2→L3)
    r = check_baku("menganalisa")
    errors = [i for i in r.issues if i.word.lower() == "menganalisa"]
    assert len(errors) >= 1, "Should flag 'menganalisa'"

    # Test 3: Valid baku word should have no issues
    r = check_baku("menganalisis")
    errors = [i for i in r.issues if i.type == "error"]
    assert len(errors) == 0, f"'menganalisis' is valid baku, but got errors: {errors}"

    # Test 4: Multiple words
    r = check_baku("Aktifitas menganalisa resiko")
    assert len(r.issues) >= 3, f"Should flag at least 3 words, got {len(r.issues)}"

    # Test 5: Stats populated
    r = check_baku("Saya menulis kata")
    assert "words_checked" in r.stats, "Stats should contain words_checked"

    print("✓ All validate_baku tests passed!")


if __name__ == "__main__":
    main()
