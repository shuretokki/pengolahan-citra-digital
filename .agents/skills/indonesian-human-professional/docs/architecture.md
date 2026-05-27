# Indonesian Academic Validator — Architecture

## Purpose

This system validates Indonesian academic writing against standards and detects AI-generated text patterns. It operates as a **language-only** validator — paper structure, Typst formatting, and bibliography rendering are handled by the `typst-paper` skill.

---

## Domains

The validator is organized into three domains:

| Domain                | Responsibility                                     |
| --------------------- | -------------------------------------------------- |
| `bahasa-core`         | EYD V, KBBI, baku validation, foreign word tagging |
| `deai-style`          | Rhythm variance, passive voice, banned AI phrases  |
| `academic-compliance` | Bloom's verbs, APA 7th localized, AI disclosure    |

---

## Pipeline Layers

```
Input Text
    │
    ├──► Group A (word-level, parallel)
    │       ├── L1: Direct baku correction (lantip JSON)
    │       ├── L2: Stemming via PySastrawi (ECS)
    │       ├── L3: Root validation against KBBI
    │       └── L9: Foreign word tagging (inverse KBBI)
    │
    └──► Group B (sentence-level, parallel)
            ├── L4: EYD di-/ke- spacing (Stanza POS)
            ├── L6: AI pattern scanning (banned phrases, conjunction stacking)
            ├── L7: Rhythm variance analysis (Breath Test)
            └── L8: Passive voice classification (Pasif Persona)
                │
                ▼
         run_all.py → Aggregate → Score (0-100)
```

### Layer Detail

| Layer | Script                 | Domain        | Tool           | What It Does                                          |
| ----- | ---------------------- | ------------- | -------------- | ----------------------------------------------------- |
| L1    | `validate_baku.py`     | `bahasa-core` | lantip JSON    | Maps tidak-baku → baku (e.g., *analisa* → *analisis*) |
| L2    | `validate_baku.py`     | `bahasa-core` | PySastrawi     | Strips affixes to find root word                      |
| L3    | `validate_baku.py`     | `bahasa-core` | KBBI dataset   | Validates root against 30k+ KBBI entries              |
| L4    | `check_eyd_spacing.py` | `bahasa-core` | Stanza POS     | Detects di-/ke- prefix vs. preposition errors         |
| L6    | `scan_ai_patterns.py`  | `deai-style`  | Stanza + regex | Flags banned phrases, conjunction stacking, em-dash   |
| L7    | `analyze_rhythm.py`    | `deai-style`  | Stanza + stats | Measures sentence length variance (monotone = AI)     |
| L8    | `classify_passive.py`  | `deai-style`  | Stanza POS     | Enforces *Pasif Persona* over standard passive        |
| L9    | `tag_foreign_words.py` | `bahasa-core` | Inverse KBBI   | Tags unabsorbed foreign terms for italicization       |

### Dependencies Between Layers

- L2 feeds L3 (root needed for KBBI lookup)
- L2 feeds L9 (root needed for inverse check)
- L8 uses L2 internally (verb root for Pasif Persona suggestion)
- All sentence-level layers (L4, L6, L7, L8) share the Stanza pipeline singleton

---

## Tool Stack

| Tool           | Version | Purpose                          |
| -------------- | ------- | -------------------------------- |
| **PySastrawi** | latest  | Indonesian stemming (ECS algo)   |
| **Stanza**     | 1.11.x  | POS tagging, tokenization (`id`) |
| **uv**         | —       | Script runner (`uv run --with`)  |

No other external dependencies. Everything else is regex or JSON lookup.

---

## Data Files

All rule data lives in `data/` as JSON. Scripts never hardcode rules.

| File                   | Size    | Used By    | Schema                            |
| ---------------------- | ------- | ---------- | --------------------------------- |
| `baku_tidak_baku.json` | ~34 KB  | L1         | `{"tidak_baku": "baku", ...}`     |
| `kbbi_roots.json`      | ~1 MB   | L3, L9     | `["root1", "root2", ...]`         |
| `banned_phrases.json`  | ~0.4 KB | L6         | `["phrase1", "phrase2", ...]`     |
| `heritage_words.json`  | ~0.3 KB | (reserved) | `["word1", "word2", ...]`         |
| `blooms_verbs.json`    | ~0.6 KB | (reserved) | `{"C1": [...], "C2": [...], ...}` |
| `locative_words.json`  | ~0.5 KB | L4         | `["sini", "sana", "mana", ...]`   |

Full schemas are documented in `data/SCHEMA.md`.

---

## Shared Module: `common.py`

All scripts import from `common.py`, which provides:

- **`Issue`** — dataclass for a single finding (severity, message, suggestion, position, rule code)
- **`LayerResult`** — dataclass wrapping a list of Issues + stats dict
- **`get_stanza_pipeline()`** — singleton, initializes once per process
- **`get_stemmer()`** — singleton PySastrawi stemmer
- **`load_data(filename)`** — cached JSON loader from `data/`
- **`read_input(args)`** — CLI helper (supports inline text, file path, or stdin)
- **`print_issues_human(result)`** — formatted CLI output with severity icons

---

## Scoring Logic

`run_all.py` aggregates all `LayerResult` objects and calculates a **Human Professional Score**:

```
Score = 100
  - 5 per error   (e.g., baku violations, banned AI phrases)
  - 2 per warning  (e.g., KBBI root miss, monotone rhythm)
  - 1 per info     (e.g., foreign word needs italics)

Final = max(0, Score)
```

---

## CLI Interface

Every script supports three modes:

```bash
# Inline text
uv run --with PySastrawi --with stanza python scripts/validate_baku.py "Aktifitas menganalisa"

# File input
uv run --with PySastrawi --with stanza python scripts/run_all.py input.txt --verbose

# Self-test
uv run --with PySastrawi --with stanza python scripts/validate_baku.py --test
```

The pipeline runner (`run_all.py`) also supports layer selection:

```bash
uv run --with PySastrawi --with stanza python scripts/run_all.py input.txt --layers L1,L7
```

---

## File Structure

```
.agents/skills/indonesian-human-professional/
├── SKILL.md                     # Skill entry point & linguistic rules
├── docs/
│   └── architecture.md          # ← This file
├── scripts/
│   ├── common.py                # Shared types, singletons, helpers
│   ├── validate_baku.py         # L1 + L2 + L3
│   ├── check_eyd_spacing.py     # L4
│   ├── scan_ai_patterns.py      # L6
│   ├── analyze_rhythm.py        # L7
│   ├── classify_passive.py      # L8
│   ├── tag_foreign_words.py     # L9
│   ├── run_all.py               # Pipeline orchestrator
│   └── setup_data.py            # One-time data acquisition
├── data/
│   ├── SCHEMA.md                # JSON format contracts
│   ├── baku_tidak_baku.json     # From lantip/baku-tidak-baku
│   ├── kbbi_roots.json          # From aryakdaniswara/kbbi-dataset
│   ├── banned_phrases.json      # Seeded from SKILL.md
│   ├── heritage_words.json      # From SKILL.md Rule VIII
│   ├── blooms_verbs.json        # KKO C1-C6
│   └── locative_words.json      # EYD di-/ke- heuristic
└── references/
```

---

## Open-Source Acknowledgments

| Resource                | Source                                                                               | License      |
| ----------------------- | ------------------------------------------------------------------------------------ | ------------ |
| Baku/Tidak-Baku mapping | [lantip/baku-tidak-baku](https://github.com/lantip/baku-tidak-baku)                  | ABRMS        |
| KBBI root dictionary    | [aryakdaniswara/kbbi-dataset](https://github.com/aryakdaniswara/kbbi-dataset-kbbi-v) | Check repo   |
| EYD V rules             | [gipsterya/eyd](https://github.com/gipsterya/eyd)                                    | CC BY-SA 4.0 |
| Stemmer roots (~30k)    | Bundled with PySastrawi                                                              | MIT          |
