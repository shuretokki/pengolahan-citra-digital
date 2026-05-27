# Module: De-AI & Humanization (DEAI)

**Trigger Keywords**: deai, humanize, reduce AI traces, anti-ai, bypass detectors
**Domain**: `anti-ai-style`
**Target Layers**: L6, L7, L8

**Objective**: Systematically lower AI detection scores in formal Indonesian literature by enforcing heritage syntax, syntactic bursts, and targeted passive structures without compromising academic rigor.

**Input Requirements**:
1. **Source Type (Required)**: Indonesian academic text (Skripsi, Thesis, Jurnal)
2. **Section (Required)**: Identify whether it's Abstract, Introduction, Methodology, or Results.
3. **Source Text (Required)**: Direct paste (retain original formatting).

---

## 1. Syntax & Rule Recognition
Detect and strictly preserve technical and formatting markers:
- **Citations & References**: Do not modify standard citation brackets (e.g., `[1]`, `(Author, 2023)`), or specific markers like `dkk.` / `et al.`
- **Formulas & Numbers**: Retain exact mathematical formulas and quantitative results (e.g., `98%`, `Rp5.000,00`).
- **Formatting**: Preserve Markdown headings, Typst tags, and specific formatting outputs.

## 2. AI Trace Detection (L6: Lexical Dissonance)
AI texts fail due to predictable, corporate fluff and repetitive transitions. (`scan_ai_patterns.py`)

**Rule: Anti-Theatrical Vocabulary (Literal Grounding)**
- **BAN Metaphors & Idioms (Majas):** Never use phrases like *pisau bermata dua*, *batu loncatan*, or *gerbang utama*. Use literal impacts (*memiliki dua dampak*).
- **BAN Philosophical Abstract Nouns:** Do not write about *esensi pemikiran*, *diskursus ruang seminar*, or *orisinalitas nalar*. Talk about the actual variables: *hasil pengolahan data*, *akurasi luaran*.
- **BAN Dramatic Verbs (Hiperbola):** Replace emotional/novel-like verbs (*menyedot, mendikte, mewujud nyata, mereduksi*) with dry, empirical actions (*mengambil, memengaruhi, diimplementasikan, menurunkan*).
- **BAN Vague Quantifiers:** Do not write "*Sebagian besar pakar menilai*" or "*Telah banyak akademisi menyoroti*". Either cite a specific author, or remove the generalization entirely.

| Type                   | AI Tell (Reject)                                                         | Human Correction (Action)                                                                                                                      |
| ---------------------- | ------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| **Empty Slogans**      | *Permadani, Sinergi, Mulus, Komprehensif, Signifikan*                    | Replace with grounded, specific KBBI roots, or delete if fluff.                                                                                |
| **Over-Transitions**   | *Penting untuk dicatat bahwa, Kesimpulannya, Namun demikian, Selain itu* | Delete entirely. Connect with a semicolon (`;`) or start directly with the subject. Use heritage transitions: *"Menurut hemat penulis"*        |
| **Robotic Academic**   | *Kecakapan, Keahlian, Ranah, Teliti, Menyelidiki*                        | Use objective nouns. Replace *menyelidiki* with *menganalisis/mengkaji*.                                                                       |
| **Anaphora Precision** | Standalone *"ini"*, *"hal tersebut"*                                     | BAN standalone *"ini"*. ENFORCE formal anchors binded to nouns: *"tersebut"*, *"di atas"*, *"terkait"*, *"yang dimaksud"*. Restate full nouns. |

## 3. Text Rewriting & Rhythmic Chaos
Apply hard mathematical constraints to break mechanical generation patterns:

- **Simplicity over Jargon (Bahasa Mahasiswa S1)**:
  - **The Problem**: When told to be "academic", LLMs generate hyper-dense, robotic jargon salad that no human uses (e.g., *"lanskap industri struktural"*, *"intervensi kognitif manual"*, *"bias turunan komputasi"*).
  - **Action**: BAN hyper-complex terminology. Write like a normal, intelligent human undergraduate.
    - Instead of *"intervensi kognitif manual"*, write **"bantuan manusia"**.
    - Instead of *"lanskap industri struktural"*, write **"berbagai sektor"**.
    - Limit noun phrases to 1-2 words. Stop stacking 4 complicated words together.
- **Lexical Density (Keep it Low)**: Humans write with natural "empty" space (common words). LLMs try to maximize the smart-sounding words per sentence. Deliberately lower the vocabulary level. If a middle-schooler wouldn't understand the word, don't use it unless it is the core topic.
- **No Summary Transitions or Filler Conclusions**:
  - LLMs constantly end paragraphs with sweeping generic summaries: *"pengawasan dosen pembimbing memegang peran penting guna memastikan validitas..."* or *"Hal ini krusial untuk masa depan..."*
  - **Action**: BAN terminal summaries entirely. End strings of thought on a concrete action, a bare metric, or a literal statement of process (*"...dan World Bank"*, *"Oleh karena itu, struktur intelektual ini dipetakan."*). Don't try to "wrap up" a thought beautifully.
- **Syntactic Compression (Intra-Sentence)**:
  - Merge related process and result steps into single, powerful complex sentences. Keep length up to around 30 words.
  - Use conjunctions like *sehingga*, *yakni*, and *yang menghasilkan* to create dense logic.
  - Do NOT force unnatural staccato bursts (e.g., *"Hasilnya akurat."*). Humans do not write in punchy micro-sentences in academic papers.
- **Forced SPO Dominance (Subjek Mendominasi)**:
  - At least 70% of sentences MUST start with a Noun/Pronoun Subject to establish authority. Use standard SPOK (*"Perkembangan AI sangat pesat"*).
  - BAN "Contextual Prepositional Openers". Do not start sentences with adverbs/prepositions (`Pada awalnya...`, `Dalam...`, `Secara teknis...`). Shift them to the middle.
- **Alih-Fokus (Contrastive Action)**:
  - AI uses static negations (*bukan X melainkan Y*). YOU MUST REPLACE THIS.
  - Use high-intent active verbs instead (e.g., *mengabaikan*, *meninggalkan*, *menitikberatkan*).
- **Enumeration Opener (Adapun-Yakni)**:
  - BAN generic AI list openers (*"Berikut adalah..."*, *"Terdapat beberapa..."*).
  - ENFORCE the *"Adapun... yakni:"* pattern for all list introductions.
- **Passive Classification (L8 "Pasif Persona")**: (`classify_passive.py`)
  - Standard passives (`di- + oleh + pronoun`) must be converted to Pasif Persona.
  - Example: *Data dianalisis oleh kami* ➔ **Data kami analisis.**
  - Override active systems with objectivity markers: *Sistem mengembangkan...* ➔ **Dikembangkan paparan oleh sistem...**

## 4. Output Generation (Audit Phase)
When returning fixes or validating against scripts, format outputs cleanly with an explicit edit log:

```text
// ============================================================
// DE-AI Edit Log (Section: Methodology)
// ============================================================
// Action: Resolved L6_BANNED_TRANSITION
// Original: Selain itu, sistem diuji oleh kami.
// Modified: Sistem kami uji.
// Reason: Deleted banned transition "Selain itu". Transformed to Pasif Persona (L8).
//
// Action: Resolved L7_LOW_VARIANCE
// Original: [30-word sentence].
// Modified: [15-word sentence]. [5-word sentence burst].
// ============================================================

= Methodology
Sistem kami uji...
```

## Hard Constraints
- **Never Modify**: Citations, metric numbers, algorithm names, or experimental setup details.
- **Never Add**: New facts, numbers, imaginary references, or conclusions not in the original text.
- **Only Modify**: Paragraph prose, transition logic, sentence length, and syntax order.

## Section-by-Section Guidelines
| Section      | Focus                                        | Constraints                                                    |
| ------------ | -------------------------------------------- | -------------------------------------------------------------- |
| Abstract     | Objective / Method / Results (with numbers)  | Ban generic contributions. No "In this paper..."               |
| Introduction | Importance -> Gap -> Verifiable Contribution | Blunt, non-poetic wording.                                     |
| Related Work | Route-based grouping, pinpoint differences   | Specific contrast rather than broad agreement.                 |
| Methodology  | Reproducibility -> Step-by-step logic        | Heavy use of Type-1 passives (*Di-*). Ban active human actors. |
| Results      | Plain facts and exact numbers                | No interpreting mechanisms or reasons here.                    |
| Discussion   | Mechanism, limits, failures, boundaries      | Critical analysis.                                             |
| Conclusion   | Answer the core problem directly             | No new experiments. Short, punchy.                             |
