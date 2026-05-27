# Workflow & Tool Execution

This module describes how agents should utilize the provided Python scripts in the `scripts/` directory to validate and fix Indonesian text.

## Validational Pipeline (L1 - L9)

When processing or reviewing a text block, the pipeline is divided into logical layers:

- **L1 & L2 & L3 (Word Core & Root Validation):** `validate_baku.py`
  - Validates if words are "baku" (standard) or "tidak-baku" (non-standard). Uses `lantip` mapping and PySastrawi.
- **L4 (Prefix vs Preposition Spacing):** `check_eyd_spacing.py`
  - Validates cases of "di-" prefix versus "di" preposition. Uses Stanza for part-of-speech context. 
- **L6 (Anti-AI Pattern Scanning):** `scan_ai_patterns.py`
  - Scans for banned AI-isms, corporate buzzwords, and repetitive paragraph transitions.
- **L7 (Rhythmic Variance Assessment):** `analyze_rhythm.py`
  - Rates text rhythm to detect mechanical sentence-length standardizations (AI telltale). Highlights where short "burst" sentences are needed.
- **L8 (Passive Classification):** `classify_passive.py`
  - Detects standard S-P-O vs "Pasif Persona" structures to ensure sentences feel human and formal.
- **L9 (Foreign Word/Loanword Tagging):** `tag_foreign_words.py`
  - Flags italicization needs and checks KBBI roots for loanwords vs native vocabulary alternatives. 

## Running the Complete Pipeline

To run all layers sequentially on a set of paragraphs or a file:

```bash
python scripts/run_all.py --input <path_to_txt>
```
*(Or use individual scripts passing `--text` or `--file` depending on the script CLI)*

## AI Agent Integration

1. **Parse Input:** Identify if the user's text is intended for an academic or formal context.
2. **Apply Rules:** Keep `DEAI.md` and `ACADEMIC_COMPLIANCE.md` constraints strictly in mind when drafting the initial response.
3. **Validate:** If drafting heavy sections of a thesis or skripsi, simulate or directly invoke the L1-L9 checklist mentality to vet the output before finalizing.
4. **Refine:** Introduce rhythmic variance (L7 checks) and remove em-dashes or stacked conjunctions (L4/L6 checks).