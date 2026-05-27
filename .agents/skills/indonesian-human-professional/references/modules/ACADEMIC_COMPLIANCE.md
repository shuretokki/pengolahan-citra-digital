# Module: Academic Compliance

**Trigger Keywords**: academic formatting, skripsita, unesa 2025, citation, pleonasme, kalimat efektif
**Domain**: `academic-compliance`
**Target Layers**: Pre-Validation & Formatting

**Objective**: Enforce strict structural, logical, and institutional formatting requirements for formal Indonesian academic writing (Skripsi, Thesis, Jurnal) to meet general standards.

**Input Requirements**:
1. **Source Type (Required)**: Indonesian academic text.
2. **Context (Required)**: Specific section being reviewed (e.g., Abstrak, Metode, Hasil).

---

## 1. Syntax & Structural Efficiency (Kalimat Efektif)
AI defaults to verbose, redundant phrasing. Apply algorithm to enforce brevity and clear `[Subjek]-[Predikat]-[Objek]` (SPOK) sequence.

| Rule Trigger                   | Invalid/AI Output (Reject)                                          | Human Standard (Action)                                                    |
| ------------------------------ | ------------------------------------------------------------------- | -------------------------------------------------------------------------- |
| **Pleonasme (Double Plurals)** | *banyak masalah-masalah*                                            | **banyak masalah** (Strip duplicated plural nouns)                         |
| **Pleonasme (Function)**       | *bertujuan untuk*, *adalah merupakan*, *agar supaya*, *mulai sejak* | **bertujuan**, **adalah** OR **merupakan**, **agar**, **sejak** (Pick one) |
| **Preposition Trap**           | *Di dalam penelitian ini membahas tentang...* (No Subject)          | **Penelitian ini membahas tentang...** (Strip opening preposition)         |
| **English-Translated Syntax**  | *untuk komputer demi belajar*                                       | **agar komputer dapat belajar** (Use native logic)                         |

## 2. Hard Punctuation & Logic Boundaries
Enforce human-style sentence connections and ban AI-heavy stylistic crutches, but allow human imperfection.

- **Lexical Repetition (ALLOW)**: AI actively avoids repeating words (e.g., using *sebagian, beberapa, sejumlah*). DO NOT DO THIS. Humans reuse mundane modifiers naturally. It is 100% fine to write *"dari berbagai jurnal, berbagai universitas, dan berbagai data"* in the same sentence. Do not use a thesaurus for functional words.
- **Imperfect Parallelism (ALLOW)**: Do not artificially perfect lists. If combining nouns, verbs, and English terms (e.g., *"dilakukan mapping, konsolidasi, dan dievaluasi"*), let the slight clunkiness remain. Perfect grammatical parallelism triggers AI detectors.
- **Conjunction Stacking (BANNED)**: Never write *"Karena X, sehingga Y, akibatnya Z"*. AI stacks too many logical jumps. Keep logical connections linear.
- **Dashes vs Commas**: Modern LLMs overuse em-dashes (`—`) to insert ideas. Use standard commas (*,*), brackets (`()`), or just break the clause into another sentence.
- **Fronted Conjunctions (Accepted Human Imperfection)**:
  - While formally incorrect in EYD, human academics natively write **"Sedangkan..."** or **"Sementara itu..."** at the beginning of a sentence. **ALLOW THIS.** This makes the text feel 100x more human than AI-constrained formal logic.
- **"Setelah itu" vs "Lalu"**: Replace the procedural *lalu* with the more academic *sementara itu*, *setelah itu*, or *kemudian*.
- **Number Formatting**:
  - Standardize real-world metrics like the 2020 WHO baseline. Use absolute, raw data (*70.228.447 kasus*, *67%*, *Rp5.000,00*). Stop writing *"jutaan parameter data"* (Generic AI phrase). Write exactly what the dataset represents.

## 3. Section & Venue Styling (Jatim-Academic Diction)
Apply exact stylistic overlays for regional academic terminology.

| Target Element                  | Standard AI Output                | Required Pivot                                                                |
| ------------------------------- | --------------------------------- | ----------------------------------------------------------------------------- |
| **Primary Pivot**               | *Yaitu*                           | **Yakni** (Enforce in 70% of instances)                                       |
| **Section Anchors**             | *Metode yang digunakan adalah...* | **Adapun,** metode yang... (Anchor *Metode/Hasil* sections)                   |
| **Diction**                     | *Hasil*, *Observasi*, *Skripsi*   | **Paparan**, **Amatan**, **Tugas Akhir**                                      |
| **Taksonomi Bloom (S1)**        | *Mengevaluasi*, *Merancang*       | **Mengidentifikasi**, **Menganalisis** (Downgrade to C1-C4 for Undergrad)     |
| **Citations (Indonesian)**      | *(Author et al.)*                 | *(Author dkk.)* (NEVER italicize *dkk.*)                                      |
| **Citations (Gaya Selingkung)** | *(Author dkk.)*                   | *(Author et al.)* (Italicize *et al.* if strictly using international format) |
| **References (APA 7th)**        | *Retrieved from...*, *Januari*    | **Diunduh dari...**, **Januari** (Hardcode localized strings/months)          |

## 4. Abstract, Scope & Numerical Grounding (Anti-Theatrical Tone)
- **Literal Grounding (Anti-Majas/Hiperbola)**: Ban ALL dramatic metaphors, philosophical idioms, and emotional verbs (e.g., *pisau bermata dua*, *mendikte*, *menyedot*, *telah mewujud nyata*). Use plain, boring, dry empirical impact words (*memiliki dampak*, *mengambil*, *mempengaruhi*).
- **Anti-Circular Logic**: Assume a highly intelligent academic audience. NEVER define commonly understood terms (e.g., what an "algorithm" is to CS faculty). Plunge into deep analysis.
- **Numerical Detail**: Strip vague generalities ("Sebagian besar sampel...", "Telah banyak akademisi"). Hardcode observable densities or explicit citations: *"Sebanyak 12 dari 15 sampel"*.
- **Abstract Phrasing**: Ban *"In this paper, we..."* translated equivalents.
  - REQUIRED Start: *"Penulisan ini bertujuan untuk..."* or *"Penelitian ini mengevaluasi dampak..."*
  - **Keywords**: Use Title Case, separated by semicolons (`;`), minimum 3 words.

---

## Output Contract
When performing an Academic Compliance review, explicitly outline structural fixes in the chat or code comment block before outputting text:

```text
// ============================================================
// ACADEMIC-COMPLIANCE Edit Log
// ============================================================
// Action: Resolved PLEONASME
// Original: Penelitian ini bertujuan untuk...
// Modified: Penelitian ini bertujuan...
//
// Action: Jatim-Academic Overlay
// Original: Hasil dari observasi menunjukkan...
// Modified: Paparan dari amatan menunjukkan...
// ============================================================
```
