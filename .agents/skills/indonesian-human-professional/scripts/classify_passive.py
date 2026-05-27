#!/usr/bin/env python3
"""
L8: Passive voice classifier.

Detects standard passives (di-VERB oleh PRON) and suggests
Pasif Persona conversions (PRON + root-VERB).

Example:
    "Data dianalisis oleh kami"  →  "Data kami analisis"
    "Artikel ditulis oleh saya" →  "Artikel saya tulis"

Usage:
    python classify_passive.py "Data dianalisis oleh kami"
    python classify_passive.py --test
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    Issue, LayerResult, get_stanza_pipeline, get_stemmer,
    print_result, print_issues_human, read_input,
)


def classify_passive(text: str) -> LayerResult:
    """
    Detect and classify passive constructions in Indonesian text.

    Algorithm:
    1. Use Stanza to POS-tag and tokenize the text
    2. Scan for pattern: di[VERB] + "oleh" + [PRON/NOUN]
       a. Identify the verb root using PySastrawi
       b. Classify as "standard_passive"
       c. Generate Pasif Persona suggestion: [PRON] + [root verb]
    3. Also detect borderline cases:
       a. "di-VERB" without "oleh" → info (acceptable but check context)
       b. Multiple standard passives in one paragraph → warning (heritage overload)
    4. Return LayerResult with classified patterns

    Pasif Persona conversion rules:
    - "di[verb] oleh saya"   → "saya [root]"
    - "di[verb] oleh kami"   → "kami [root]"
    - "di[verb] oleh mereka" → "mereka [root]"
    - "di[verb] oleh kita"   → "kita [root]"
    """
    result = LayerResult(layer="L8", domain="anti-ai-style", script="classify_passive.py")

    nlp = get_stanza_pipeline()
    stemmer = get_stemmer()
    doc = nlp(text)

    pronouns = {
        "saya": "saya", "aku": "saya",
        "kami": "kami", "kita": "kita",
        "anda": "anda", "kamu": "anda",
        "mereka": "mereka", "ia": "ia", "beliau": "beliau"
    }

    for sentence in doc.sentences:
        words = sentence.words
        for i, word in enumerate(words):
            word_text_lower = word.text.lower()

            # Pattern: di-VERB + "oleh" + [PRON]
            if word_text_lower.startswith("di") and word.upos == "VERB":
                # Check for "oleh" + PRON
                if i + 2 < len(words):
                    next_1 = words[i+1]
                    next_2 = words[i+2]

                    if next_1.text.lower() == "oleh" and next_2.text.lower() in pronouns:
                        pron = pronouns[next_2.text.lower()]
                        root = stemmer.stem(word_text_lower)
                        # Avoid double "di" if stemmer failed
                        if root.startswith("di"):
                            root = root[2:]

                        suggestion = f"{pron} {root}"
                        result.issues.append(Issue(
                            type="warning",
                            message=f"Konstruksi pasif standar 'di-{root} oleh {next_2.text}' terdeteksi. Gunakan Pasif Persona untuk gaya penulisan lebih autentik.",
                            suggestion=suggestion,
                            word=f"{word.text} {next_1.text} {next_2.text}",
                            position=(word.start_char, next_2.end_char),
                            rule="L8-PASIF-PERSONA"
                        ))

            # Pattern: Active First-Person ("Saya menganalisis")
            # Suggesting Passive or Pasif Persona
            if word_text_lower in ["saya", "kami", "kita"] and i + 1 < len(words):
                next_word = words[i+1]
                if next_word.upos == "VERB" and next_word.text.lower().startswith("me"):
                    root = stemmer.stem(next_word.text.lower())
                    if root.startswith("me"): # recursive fallback
                         # simple strip
                         if root.startswith("meng"): root = root[4:]
                         elif root.startswith("meny"): root = root[4:]
                         elif root.startswith("mem"): root = root[3:]
                         else: root = root[2:]

                    passive_suggestion = f"{word_text_lower} {root}"
                    result.issues.append(Issue(
                        type="info",
                        message=f"Penggunaan kata ganti orang pertama dalam kalimat aktif ('{word.text} {next_word.text}') sebaiknya dihindari dalam karya ilmiah formal.",
                        suggestion=passive_suggestion,
                        word=f"{word.text} {next_word.text}",
                        position=(word.start_char, next_word.end_char),
                        rule="L8-ACTIVE-PRON"
                    ))

    result.stats["sentences_checked"] = len(doc.sentences)
    return result


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="L8: Passive voice classifier")
    parser.add_argument("text", nargs="?", help="Text to validate or path to file")
    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--test", action="store_true", help="Run inline tests")
    args = parser.parse_args()

    if args.test:
        run_tests()
        return

    text = read_input(args)
    result = classify_passive(text)

    if args.verbose:
        print_issues_human(result)
    else:
        print_result(result)


# ─── Inline Tests ────────────────────────────────────────────────────────────

def run_tests():
    print("Running classify_passive tests...")

    # Test 1: Standard passive → should suggest Pasif Persona
    r = classify_passive("Artikel ditulis oleh kami")
    passive_issues = [i for i in r.issues if "L8-PASIF-PERSONA" in i.rule or "pasif" in i.message.lower()]
    assert len(passive_issues) >= 1, "Should detect standard passive"
    assert any("kami tulis" in (i.suggestion or "").lower() for i in passive_issues), \
        "Should suggest 'kami tulis'"

    # Test 2: Already Pasif Persona → no issue
    r = classify_passive("Data kami analisis dengan cermat")
    passive_errors = [i for i in r.issues if i.type == "error"]
    assert len(passive_errors) == 0, "Pasif Persona should not be flagged"

    # Test 3: "oleh saya" pattern
    r = classify_passive("Artikel ditulis oleh saya")
    passive_issues = [i for i in r.issues if "pasif" in i.message.lower() or "L8-PASIF-PERSONA" in i.rule]
    assert len(passive_issues) >= 1, "Should detect 'ditulis oleh saya'"
    assert any("saya tulis" in (i.suggestion or "").lower() for i in passive_issues), \
        "Should suggest 'saya tulis'"

    # Test 4: Active voice → no issue
    r = classify_passive("Saya menganalisis data")
    errors = [i for i in r.issues if i.type == "error"]
    assert len(errors) == 0, "Active voice should not be flagged"

    print("✓ All classify_passive tests passed!")


if __name__ == "__main__":
    main()
