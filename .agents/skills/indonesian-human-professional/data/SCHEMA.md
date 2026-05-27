# Data File Schemas

All data files live in `data/` and are loaded by `scripts/common.py:load_data()`.

## baku_tidak_baku.json

**Source:** Merged from [lantip/baku-tidak-baku](https://github.com/lantip/baku-tidak-baku)
**Used by:** L1 (validate_baku.py)

```json
{
  "aktifitas": "aktivitas",
  "analisa": "analisis",
  "apotik": "apotek",
  "praktek": "praktik",
  "silahkan": "silakan",
  "resiko": "risiko",
  "sekedar": "sekadar",
  "...": "..."
}
```

**Format:** `{"tidak_baku_lowercase": "baku_lowercase"}` — simple key-value mapping.

---

## kbbi_roots.json

**Source:** Extracted from [aryakdaniswara/kbbi-dataset-kbbi-v](https://github.com/aryakdaniswara/kbbi-dataset-kbbi-v)
**Used by:** L3 (validate_baku.py), L9 (tag_foreign_words.py)

```json
["abjad", "abon", "abstrak", "acara", "adat", "adik", "..."]
```

**Format:** Flat list of valid Indonesian root words (lowercase). Used as a lookup set.

---

## banned_phrases.json

**Source:** Seeded from SKILL.md Standards A + B
**Used by:** L6 (scan_ai_patterns.py)

```json
[
  "penting untuk dicatat bahwa",
  "kesimpulannya",
  "namun demikian",
  "hal ini menunjukkan bahwa",
  "dapat diamati bahwa",
  "selain itu",
  "sebagai catatan",
  "intinya adalah",
  "mari kita telaah lebih dalam",
  "tapestri dari",
  "penting untuk mempertimbangkan",
  "mari kita selami",
  "lebih-lebih lagi",
  "sebuah bukti",
  "saat menavigasi kompleksitas",
  "permadani",
  "sinergi",
  "bernuansa",
  "komprehensif"
]
```

**Format:** Flat list of banned phrases/words (lowercase). Substring match.

---

## heritage_words.json

**Source:** From SKILL.md Rule VIII
**Used by:** Future use (style enrichment checking)

```json
{
  "suggested": [
    "seiring berjalannya waktu",
    "bahwasanya",
    "menurut hemat penulis",
    "adapun",
    "paparan",
    "amatan"
  ],
  "replacements": {
    "hasil": "paparan",
    "observasi": "amatan",
    "skripsi": "tugas akhir"
  }
}
```

---

## blooms_verbs.json

**Source:** Standard Indonesian KKO Taksonomi Bloom tables
**Used by:** Future use (academic-compliance domain)

```json
{
  "C1": ["menyebutkan", "menghafal", "mendaftar", "menamai", "memilih"],
  "C2": ["menjelaskan", "mengklasifikasikan", "meringkas", "membandingkan"],
  "C3": ["melaksanakan", "mempraktikkan", "mendemonstrasikan", "menggunakan"],
  "C4": ["menganalisis", "membedakan", "mengorganisasi", "menghubungkan"],
  "C5": ["memeriksa", "mengkritik", "membuktikan", "membenarkan", "menilai"],
  "C6": ["merancang", "membangun", "merencanakan", "memproduksi"]
}
```

**Format:** Grouped by cognitive level. S1 uses C1-C4, S2/S3 uses C5-C6.
