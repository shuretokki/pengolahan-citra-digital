#!/usr/bin/env python3
"""
L9: Foreign word tagger.

Checks each word root against the KBBI root list. Words NOT found
are tagged as foreign (and should be italicized in academic writing).

Usage:
    python tag_foreign_words.py "Menggunakan framework machine learning"
    python tag_foreign_words.py --test
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    Issue, LayerResult, get_stemmer, load_data,
    print_result, print_issues_human, read_input,
)


def tag_foreign_words(text: str) -> LayerResult:
    """
    Tag foreign words that need italicization in academic writing.

    Algorithm:
    1. Tokenize text into words (strip punctuation)
    2. For each word:
       a. Convert to lowercase
       b. Stem with PySastrawi to get root
       c. Check root against kbbi_roots.json
       d. If NOT in KBBI → tag as "foreign", suggest italicization
    3. Skip common proper nouns, numbers, and abbreviations
    4. Return LayerResult with tagged words

    Data files required:
    - data/kbbi_roots.json  →  ["root1", "root2", ...]
    """
    import re
    result = LayerResult(layer="L9", domain="bahasa-core", script="tag_foreign_words.py")

    # Load data
    kbbi_roots = set(load_data("kbbi_roots.json"))
    stemmer = get_stemmer()

    # Simple tokenization: extract words and their positions
    words_count = 0
    pattern = re.compile(r"\b[A-Za-z]+\b") # Only Latin characters, ignore numbers

    for match in pattern.finditer(text):
        word = match.group()
        start, end = match.span()
        word_lower = word.lower()
        words_count += 1

        # Skip if word is already a valid KBBI root
        if word_lower in kbbi_roots:
            continue

        # Stem and check if root is in KBBI
        root = stemmer.stem(word_lower)
        if root in kbbi_roots:
            continue

        # If not in KBBI, it's potentially foreign
        # Note: We use INFO level as it's a stylistic rule rather than a hard error
        result.issues.append(Issue(
            type="info",
            message=f"Kata '{word}' terdeteksi sebagai istilah asing. Gunakan format miring (italics) dalam karya ilmiah.",
            suggestion=f"*{word}*",
            word=word,
            position=(start, end),
            rule="L9-FOREIGN-TAG"
        ))

    result.stats["words_checked"] = words_count
    return result


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="L9: Foreign word tagger")
    parser.add_argument("text", nargs="?", help="Text to validate or path to file")
    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--test", action="store_true", help="Run inline tests")
    args = parser.parse_args()

    if args.test:
        run_tests()
        return

    text = read_input(args)
    result = tag_foreign_words(text)

    if args.verbose:
        print_issues_human(result)
    else:
        print_result(result)


# ─── Inline Tests ────────────────────────────────────────────────────────────

def run_tests():
    print("Running tag_foreign_words tests...")

    # Test 1: English word should be tagged foreign
    r = tag_foreign_words("Menggunakan framework untuk pengembangan")
    foreign = [i for i in r.issues if i.word.lower() == "framework"]
    assert len(foreign) >= 1, "Should tag 'framework' as foreign"

    # Test 2: Indonesian word should NOT be tagged
    r = tag_foreign_words("Menggunakan kerangka untuk pengembangan")
    foreign = [i for i in r.issues if i.word.lower() == "kerangka"]
    assert len(foreign) == 0, "'kerangka' is Indonesian, should not be tagged"

    # Test 3: Multiple foreign words
    r = tag_foreign_words("Sistem machine learning dan deep learning")
    foreign = [i for i in r.issues if i.type == "info"]
    assert len(foreign) >= 2, "Should tag multiple foreign words"

    # Test 4: Numbers should NOT be tagged
    r = tag_foreign_words("Tahun 2024 ada 50 sampel")
    foreign = [i for i in r.issues if i.word in ("2024", "50")]
    assert len(foreign) == 0, "Numbers should not be tagged"

    print("✓ All tag_foreign_words tests passed!")


if __name__ == "__main__":
    main()
