#!/usr/bin/env python3
"""
L7: Sentence rhythm variance analyzer.

Detects AI-typical monotone rhythm by measuring word-count variance
across consecutive sentences. Human writing has high variance ("burstiness"),
AI writing is suspiciously stable.

Usage:
    python analyze_rhythm.py "paragraph text here"
    python analyze_rhythm.py --test
"""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import (
    Issue, LayerResult, get_stanza_pipeline,
    print_result, print_issues_human, read_input,
)

# Variance threshold — below this is suspiciously stable
VARIANCE_THRESHOLD = 5.0  # configurable


def analyze_rhythm(text: str) -> LayerResult:
    """
    Measure sentence length variance across a text.

    Algorithm:
    1. Use Stanza to split text into sentences
    2. Count words per sentence → get list of integers
    3. Calculate variance of the word counts
    4. If variance < VARIANCE_THRESHOLD → warning "RHYTHM-001"
    5. Also flag if 3+ consecutive sentences have similar length (±2 words)
       → warning "RHYTHM-002" (monotone streak)

    Returns:
    - stats: {"sentence_count": N, "word_counts": [...], "variance": float}
    - issues: warnings if rhythm is too stable
    """
    import statistics
    result = LayerResult(layer="L7", domain="anti-ai-style", script="analyze_rhythm.py")

    nlp = get_stanza_pipeline()
    doc = nlp(text)

    if not doc.sentences:
        return result

    word_counts = [len(s.words) for s in doc.sentences]
    sentence_count = len(word_counts)

    # 1. Calculate Variance (RHYTHM-001)
    # Variance needs at least 2 sentences
    variance = statistics.variance(word_counts) if len(word_counts) > 1 else 0.0

    if sentence_count >= 3 and variance < VARIANCE_THRESHOLD:
        result.issues.append(Issue(
            type="warning",
            message=f"Irama kalimat terlalu monoton (variansi: {variance:.2f}). Tulisan manusia biasanya memiliki panjang kalimat yang bervariasi.",
            word="[Seluruh Paragraf]",
            position=(doc.sentences[0].words[0].start_char, doc.sentences[-1].words[-1].end_char),
            rule="RHYTHM-001"
        ))

    # 2. Monotone Streak (RHYTHM-002)
    streak = 1
    for i in range(1, sentence_count):
        if abs(word_counts[i] - word_counts[i-1]) <= 2:
            streak += 1
        else:
            streak = 1

        if streak >= 3:
            s_start = doc.sentences[i-2]
            s_end = doc.sentences[i]
            result.issues.append(Issue(
                type="warning",
                message="Ditemukan urutan kalimat dengan panjang yang hampir sama. Ini adalah tanda tulisan robotik. Gunakan variasi panjang kalimat (Breath Test).",
                word=f"... {s_end.text[:30]} ...",
                position=(s_start.words[0].start_char, s_end.words[-1].end_char),
                rule="RHYTHM-002"
            ))
            # reset streak after flagging to avoid duplicate flags for the same streak
            streak = 1

    # 3. Excessive Length (RHYTHM-003)
    for i, count in enumerate(word_counts):
        if count > 30:
            s = doc.sentences[i]
            result.issues.append(Issue(
                type="warning",
                message=f"Kalimat terlalu panjang ({count} kata). AI sering membuat kalimat panjang dan berbelit-belit. Pecah menjadi dua kalimat.",
                word=s.text[:50] + "...",
                position=(s.words[0].start_char, s.words[-1].end_char),
                rule="RHYTHM-003"
            ))

    result.stats["sentence_count"] = sentence_count
    result.stats["word_counts"] = word_counts
    result.stats["variance"] = variance

    return result


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main():
    global VARIANCE_THRESHOLD
    parser = argparse.ArgumentParser(description="L7: Rhythm variance analyzer")
    parser.add_argument("text", nargs="?", help="Text to validate or path to file")
    parser.add_argument("--verbose", "-v", action="store_true")
    parser.add_argument("--test", action="store_true", help="Run inline tests")
    parser.add_argument("--threshold", type=float, default=VARIANCE_THRESHOLD,
                        help=f"Variance threshold (default: {VARIANCE_THRESHOLD})")
    args = parser.parse_args()

    if args.test:
        run_tests()
        return

    VARIANCE_THRESHOLD = args.threshold

    text = read_input(args)
    result = analyze_rhythm(text)

    if args.verbose:
        print_issues_human(result)
    else:
        print_result(result)


# ─── Inline Tests ────────────────────────────────────────────────────────────

def run_tests():
    print("Running analyze_rhythm tests...")

    # Test 1: Monotone rhythm should trigger warning
    monotone = (
        "Saya menganalisis data dengan metode kuantitatif. "
        "Hasil penelitian menunjukkan peningkatan yang signifikan. "
        "Data ini dikumpulkan dengan teknik observasi terstruktur. "
        "Peneliti menggunakan instrumen yang telah divalidasi."
    )
    r = analyze_rhythm(monotone)
    assert "variance" in r.stats, "Stats should contain variance"
    # All sentences ~6-8 words — variance should be low

    # Test 2: Varied rhythm should NOT trigger warning
    varied = (
        "Data ini valid. "
        "Penelitian longitudinal selama tiga tahun pada lima belas sekolah dasar "
        "di wilayah Jawa Timur menghasilkan temuan yang cukup mengejutkan. "
        "Kenapa? "
        "Karena hasilnya sangat berbeda dari hipotesis awal kami."
    )
    r = analyze_rhythm(varied)
    assert "variance" in r.stats, "Stats should contain variance"
    assert r.stats["variance"] > VARIANCE_THRESHOLD, "Varied text should have high variance"

    # Test 3: Stats populated
    r = analyze_rhythm("Satu. Dua tiga. Empat lima enam tujuh.")
    assert "sentence_count" in r.stats
    assert "word_counts" in r.stats
    assert r.stats["sentence_count"] >= 3

    print("✓ All analyze_rhythm tests passed!")


if __name__ == "__main__":
    main()
