#!/usr/bin/env python3
"""
Pipeline runner: executes all validation layers and aggregates results.

Usage:
    python run_all.py "text to validate"
    python run_all.py input.txt
    python run_all.py input.txt --verbose
    python run_all.py input.txt --layers L1,L4,L6
"""

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from common import Issue, LayerResult, print_issues_human, read_input

# Import all layer check functions
from validate_baku import check_baku
from check_eyd_spacing import check_eyd_spacing
from scan_ai_patterns import scan_ai_patterns
from analyze_rhythm import analyze_rhythm
from classify_passive import classify_passive
from tag_foreign_words import tag_foreign_words


# ─── Layer Registry ──────────────────────────────────────────────────────────

LAYERS = {
    "L1": ("validate_baku (L1+L2+L3)", check_baku),
    "L4": ("check_eyd_spacing", check_eyd_spacing),
    "L6": ("scan_ai_patterns", scan_ai_patterns),
    "L7": ("analyze_rhythm", analyze_rhythm),
    "L8": ("classify_passive", classify_passive),
    "L9": ("tag_foreign_words", tag_foreign_words),
}


def run_pipeline(text: str, selected_layers: list[str] | None = None) -> list[LayerResult]:
    """
    Run all (or selected) validation layers on the input text.

    Algorithm:
    1. Determine which layers to run (all or --layers subset)
    2. Execute each layer's check function
    3. Collect and return all LayerResults
    4. Handle errors gracefully — if one layer fails, continue with others
    """
    results = []
    layers_to_run = selected_layers if selected_layers else list(LAYERS.keys())

    for layer_id in layers_to_run:
        if layer_id not in LAYERS:
            print(f"Warning: Layer {layer_id} not found in registry.", file=sys.stderr)
            continue

        name, func = LAYERS[layer_id]
        try:
            # print(f"Running {name}...", file=sys.stderr)
            result = func(text)
            results.append(result)
        except Exception as e:
            print(f"Error executing layer {layer_id} ({name}): {e}", file=sys.stderr)
            # Create a placeholder result for failure
            results.append(LayerResult(
                layer=layer_id,
                domain="error",
                script="run_all.py",
                issues=[Issue(type="error", message=f"Layer internal failure: {e}", word="", position=(0,0), rule="SYSTEM-ERR")]
            ))

    return results

def calculate_score(results: list[LayerResult]) -> int:
    """
    Calculate a human professional score from 0-100.
    """
    score = 100
    for res in results:
        for issue in res.issues:
            if issue.type == "error":
                score -= 5
            elif issue.type == "warning":
                score -= 2
            elif issue.type == "info":
                score -= 1
    return max(0, score)


# ─── CLI ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Indonesian Validator Pipeline")
    parser.add_argument("text", nargs="?", help="Text to validate or path to file")
    parser.add_argument("--verbose", "-v", action="store_true", help="Human-readable output")
    parser.add_argument("--layers", type=str, default=None,
                        help="Comma-separated layer IDs to run (e.g., L1,L4,L6)")
    args = parser.parse_args()

    text = read_input(args)
    selected = args.layers.split(",") if args.layers else None
    results = run_pipeline(text, selected)
    score = calculate_score(results)

    if args.verbose:
        print("\n" + "="*60)
        print(f" INDONESIAN ACADEMIC VALIDATOR REPORT")
        print("="*60)
        for result in results:
            print_issues_human(result)
        print("="*60)
        print(f" FINAL HUMAN PROFESSIONAL SCORE: {score}/100")
        print("="*60)
    else:
        output = {
            "score": score,
            "layers": [r.to_dict() for r in results]
        }
        print(json.dumps(output, ensure_ascii=False, indent=2))

    # Summary stderr
    total_issues = sum(len(r.issues) for r in results)
    total_errors = sum(1 for r in results for i in r.issues if i.type == "error")
    print(f"\n--- Processed {len(results)} layers: {total_issues} issues ({total_errors} errors), Score: {score} ---",
          file=sys.stderr)


if __name__ == "__main__":
    main()
