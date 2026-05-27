# BAHASA_CORE Module Reference

Domain: `bahasa-core`
Layers: L1, L2, L3, L4, L9

---

## Purpose

This module handles **word-level correctness** in Indonesian academic writing. It validates spelling against EYD V, checks word roots against KBBI, enforces baku (standard) forms, detects di-/ke- spacing errors, and tags foreign words that need italicization.

---

## Layers

### L1 — Direct Baku Correction

**Script:** `scripts/validate_baku.py`
**Data:** `data/baku_tidak_baku.json`
**Severity:** Error

Performs a direct dictionary lookup of each word against the baku mapping. If a word has a known baku equivalent, it flags the word and suggests the correction.

| Input        | Output              |
| ------------ | ------------------- |
| aktifitas    | → aktivitas (error) |
| analisa      | → analisis (error)  |
| nasehat      | → nasihat (error)   |
| ijin         | → izin (error)      |
| menganalisis | ✓ (no issue)        |

**Skip rules:**
- Digits are ignored
- Capitalized words are treated as proper nouns and skipped

---

### L2 — Root Word Extraction (Stemming)

**Script:** `scripts/validate_baku.py` (same script, pipeline step)
**Tool:** PySastrawi (Enhanced Confix Stripping)
**Severity:** N/A (internal step)

Strips all affixes from a word to produce the root form. This root is then passed to L3 for KBBI validation and to L9 for foreign word detection.

| Input        | Root     |
| ------------ | -------- |
| menganalisis | analisis |
| pembangunan  | bangun   |
| keberhasilan | hasil    |
| dituliskan   | tulis    |

**Morphology reference:** See `references/MORPHOLOGY.md` for full affix tables and morphophonemic rules.

---

### L3 — KBBI Root Validation

**Script:** `scripts/validate_baku.py` (same script, pipeline step)
**Data:** `data/kbbi_roots.json` (~30k roots)
**Severity:** Warning

After stemming, checks whether the root word exists in the KBBI dictionary. If not found, the word may be non-standard or a foreign loan.

| Root      | In KBBI? | Result       |
| --------- | -------- | ------------ |
| tulis     | Yes      | ✓ (no issue) |
| analisis  | Yes      | ✓ (no issue) |
| prompt    | No       | ⚠ Warning    |
| framework | No       | ⚠ Warning    |

**Note:** L3 warnings often overlap with L9 foreign word detections. Both are reported independently for different purposes (L3 = possible non-baku, L9 = needs italic formatting).

---

### L4 — EYD di-/ke- Spacing

**Script:** `scripts/check_eyd_spacing.py`
**Tool:** Stanza POS tagging
**Data:** `data/locative_words.json`
**Severity:** Error

Detects whether `di` and `ke` are correctly used as prefixes (joined) vs. prepositions (separated).

**Core rule:**
- `di` + **verb** → join: `dimakan`, `ditulis`, `dianalisis`
- `di` + **noun/place** → separate: `di rumah`, `di sini`, `di mana`

| Input       | POS Context | Verdict                  |
| ----------- | ----------- | ------------------------ |
| dimakan     | di + verb   | ✓ Correct                |
| di rumah    | di + noun   | ✓ Correct                |
| di analisis | di + verb   | ✗ Should be `dianalisis` |
| dirumah     | di + noun   | ✗ Should be `di rumah`   |

**Heuristic:** The script uses a locative word list (`sini`, `sana`, `mana`, `atas`, `bawah`, etc.) as a fallback when POS tagging is ambiguous.

---

### L9 — Foreign Word Tagging

**Script:** `scripts/tag_foreign_words.py`
**Data:** `data/kbbi_roots.json` (inverse lookup)
**Severity:** Info

Identifies words whose root form is not found in KBBI, suggesting they are foreign/unabsorbed terms. In academic writing, these must be italicized per EYD V rules.

| Input     | Root      | In KBBI? | Suggestion    |
| --------- | --------- | -------- | ------------- |
| framework | framework | No       | → *framework* |
| prompt    | prompt    | No       | → *prompt*    |
| database  | database  | No       | → *database*  |
| analisis  | analisis  | Yes      | ✓ (no issue)  |

---

## Data Files

| File                   | Format                          | Source                                                                               |
| ---------------------- | ------------------------------- | ------------------------------------------------------------------------------------ |
| `baku_tidak_baku.json` | `{"tidak_baku": "baku", ...}`   | [lantip/baku-tidak-baku](https://github.com/lantip/baku-tidak-baku)                  |
| `kbbi_roots.json`      | `["root1", "root2", ...]`       | [aryakdaniswara/kbbi-dataset](https://github.com/aryakdaniswara/kbbi-dataset-kbbi-v) |
| `locative_words.json`  | `["sini", "sana", "mana", ...]` | Hand-curated from EYD V preposition rules                                            |

---

## Error Codes

| Code             | Layer | Severity | Description                         |
| ---------------- | ----- | -------- | ----------------------------------- |
| `L1-BAKU-DIRECT` | L1    | Error    | Non-standard word with baku mapping |
| `L3-KBBI-ROOT`   | L3    | Warning  | Root word not found in KBBI         |
| `L4-EYD-PREFIX`  | L4    | Error    | di-/ke- spacing violation           |
| `L9-FOREIGN-TAG` | L9    | Info     | Foreign word needs italicization    |

---

## Typography & Formatting (EYD V Micro-Rules)

- **Vertical Lists (Rincian Vertikal):** For short lists (phrases), use a semicolon (;) to separate each item and a period (.) at the very end of the list.
- **Academic Titles (Gelar):** Use a dot after each abbreviation and a comma after the name. (e.g., *Budi, S.Kom., M.T.*)
- **Hybrid Foreign Terms:** If an Indonesian prefix is added to a non-absorbed foreign word, ONLY the foreign root is italicized. (e.g., **me-***upgrade*)
- **Foreign Terms:** If a word feels "smart" or "technical," check if it's in the KBBI. If it isn't (e.g., *download*), italicize it. Do not force weird Indonesianizations unless standard.

---

## KBBI Daring Logic (Standardization)

Only use standard (baku) words from the KBBI for the foundational professional structure.

- **Common Mistakes (TIDAK BAKU vs. BAKU):**
  - Aktifitas (NO) -> Aktivitas (YES)
  - Analisa (NO) -> Analisis (YES)
  - Apotik (NO) -> Apotek (YES)
  - Praktek (NO) -> Praktik (YES)
  - Silahkan (NO) -> Silakan (YES)
  - Resiko (NO) -> Risiko (YES)
  - Sekedar (NO) -> Sekadar (YES)

- **Loanword Absorption Rules:**
  - -ity -> -itas (Quality -> Kualitas, Actuality -> Aktualitas)
  - -ism -> -isme (Capitalism -> Kapitalisme)
  - -tion -> -si (Action -> Aksi, Function -> Fungsi)

- **The KTSP Rule (Prefix Melting):** Standard prefixes (me- and pe-) MUST melt root words starting with K, T, S, P followed by a vowel.
  - GOOD: *Me- + Kompilasi = **Mengompilasi*** (Not *Mengkompilasi*).
  - GOOD: *Me- + Sinkron = **Menyinkronkan*** (Not *Mensinkronkan*).

- **Correct Diction (Bukan vs. Tidak):**
  - **Bukan** is for Nouns (*Bukan software*).
  - **Tidak** is for Verbs/Adjectives (*Tidak berjalan*).
  - **Redundancy:** NEVER use *"Bukan merupakan"*. Just use *"Bukan"* or *"Bukanlah"*.

- **Technical IT Vocabulary (Daring/Luring):**
  - *Daring* (Online), *Luring* (Offline).
  - *Unduh* (Download), *Unggah* (Upload).
  - *Pranala* (Link), *Laman* (Page), *Surel* (Email).
  - *Pembaruan* (Update), *Setelan* (Settings/Setup).

- **Common Spacing Errors:**
  - **Di mana / Ke mana** (Must be separated).
  - **Antarkota / Antarbangsa** (Prefix *antar-* is joined).
  - **Pascasarjana / Tunawisma** (Prefixes *pasca-*, *tuna-* are joined).
