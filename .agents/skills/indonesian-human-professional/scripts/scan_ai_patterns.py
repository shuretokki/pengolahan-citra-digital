#!/usr/bin/env python3
"""
L6: AI writing pattern scanner.

Scans sentences for banned AI-ism phrases, excessive conjunction stacking,
and ChatGPT-typical patterns.

Usage:
    python scan_ai_patterns.py "Penting untuk dicatat bahwa hal ini menunjukkan..."
    python scan_ai_patterns.py --test
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    Issue, LayerResult, get_stanza_pipeline, load_data,
    print_result, print_issues_human, read_input,
)


def scan_ai_patterns(text: str) -> LayerResult:
    """
    Scan text for AI-typical writing patterns.

    Algorithm:
    1. Use Stanza to split text into sentences
    2. For each sentence:
       a. Check against banned_phrases.json (substring match, case-insensitive)
          - Report each match as error with rule "AI-ISM-001"
       b. Count conjunctions per sentence (dan, serta, namun, tetapi, sedangkan)
          - If > 3 conjunctions in one sentence → warning "CONJ-STACK-001"
       c. Check for em-dash usage (—) → error "EM-DASH-001"
       d. Check if sentence starts with "Sedangkan" or "Sehingga" → error "EYD-CONJ-001"
    3. Return LayerResult

    Data files required:
    - data/banned_phrases.json  →  ["phrase1", "phrase2", ...]
    """
    import re
    result = LayerResult(layer="L6", domain="anti-ai-style", script="scan_ai_patterns.py")

    # Load data
    banned_phrases = load_data("banned_phrases.json")
    nlp = get_stanza_pipeline()
    doc = nlp(text)

    conjunctions = ["dan", "serta", "namun", "tetapi", "sedangkan", "sehingga", "maupun"]

    for sentence in doc.sentences:
        sent_text = sentence.text
        sent_text_lower = sent_text.lower()

        # 1. Banned Phrases (L6-AI-ISM)
        for phrase in banned_phrases:
            if phrase.lower() in sent_text_lower:
                # Find position (simple search for now, could be improved with regex)
                start_idx = sent_text_lower.find(phrase.lower())
                abs_start = sentence.words[0].start_char + start_idx
                abs_end = abs_start + len(phrase)

                result.issues.append(Issue(
                    type="error",
                    message=f"Pola tulisan AI terdeteksi: '{phrase}'. Hindari frasa klise AI.",
                    word=phrase,
                    position=(abs_start, abs_end),
                    rule="AI-ISM-001"
                ))

        # 2. Conjunction Stacking (L6-CONJ-STACK)
        count = 0
        for word in sentence.words:
            if word.text.lower() in conjunctions:
                count += 1
        if count > 3:
            result.issues.append(Issue(
                type="warning",
                message=f"Kalimat memiliki terlalu banyak konjungsi ({count}). Kalimat terlalu kompleks, berisiko terdeteksi AI.",
                word=sent_text,
                position=(sentence.words[0].start_char, sentence.words[-1].end_char),
                rule="CONJ-STACK-001"
            ))

        # 3. Em-dash usage (L6-EM-DASH)
        # AI often uses em-dash (—) for nested clauses.
        if "—" in sent_text:
            result.issues.append(Issue(
                type="error",
                message="Penggunaan em-dash (—) terdeteksi. Ini adalah pola khas ChatGPT. Gunakan struktur SPOK yang lebih sederhana.",
                word="—",
                position=(sentence.words[0].start_char, sentence.words[-1].end_char),
                rule="EM-DASH-001"
            ))

        # 4. EYD: Sentence starting with conjunctions (EYD-CONJ-001)
        # Rule: Sedangkan dan Sehingga tidak boleh di awal kalimat.
        first_word = sentence.words[0].text.lower()
        if first_word in ["sedangkan", "sehingga"]:
            result.issues.append(Issue(
                type="error",
                message=f"Kalimat tidak boleh diawali dengan kata konjungsi '{sentence.words[0].text}'.",
                word=sentence.words[0].text,
                position=(sentence.words[0].start_char, sentence.words[0].end_char),
                rule="EYD-CONJ-001"
            ))

    result.stats["sentences_checked"] = len(doc.sentences)
    return result


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="L6: AI pattern scanner")
    parser.add_argument("text", nargs="?", help="Text to validate or path to file")
    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--test", action="store_true", help="Run inline tests")
    args = parser.parse_args()

    if args.test:
        run_tests()
        return

    text = read_input(args)
    result = scan_ai_patterns(text)

    if args.verbose:
        print_issues_human(result)
    else:
        print_result(result)


# ─── Inline Tests ────────────────────────────────────────────────────────────

def run_tests():
    print("Running scan_ai_patterns tests...")

    # Test 1: Detect banned AI-ism phrase
    r = scan_ai_patterns("Penting untuk dicatat bahwa hal ini sangat penting.")
    ai_issues = [i for i in r.issues if i.rule == "AI-ISM-001"]
    assert len(ai_issues) >= 1, "Should flag 'Penting untuk dicatat bahwa'"

    # Test 2: Detect em-dash
    r = scan_ai_patterns("Data ini — yang sangat penting — harus dianalisis.")
    em_issues = [i for i in r.issues if i.rule == "EM-DASH-001"]
    assert len(em_issues) >= 1, "Should flag em-dash usage"

    # Test 3: Detect conjunction stacking
    r = scan_ai_patterns("Karena data ini penting dan besar serta luas dan mendalam serta bermakna.")
    conj_issues = [i for i in r.issues if i.rule == "CONJ-STACK-001"]
    assert len(conj_issues) >= 1, "Should flag conjunction stacking"

    # Test 4: Sentence starting with banned conjunction
    r = scan_ai_patterns("Sedangkan hasil lainnya menunjukkan hal berbeda.")
    conj_start = [i for i in r.issues if i.rule == "EYD-CONJ-001"]
    assert len(conj_start) >= 1, "Should flag sentence starting with 'Sedangkan'"

    # Test 5: Clean sentence should pass
    r = scan_ai_patterns("Saya menganalisis data dengan metode kuantitatif.")
    errors = [i for i in r.issues if i.type == "error"]
    assert len(errors) == 0, "Clean sentence should have no errors"

    print("✓ All scan_ai_patterns tests passed!")


if __name__ == "__main__":
    main()
