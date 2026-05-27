---
name: indonesian-human-professional
description: 'Expert-level Indonesian professional writing standard integrating KBBI Daring, EYD V (Ejaan.id), and Skripsita logic with a rigorously anti-corporate, human-like voice. Uses advanced anti-AI-detection techniques (Pasif Persona, sentence inversions) and enforcing academic guidelines. USE FOR: writing academic papers, skripsi, thesis, formal journal reviews, professional Indonesian emails, and anytime the user asks for formal Indonesian texts without sounding like an AI. DO NOT USE FOR: casual slang, creative fiction, or languages other than Indonesian.'
license: MIT
compatibility: No specific requirements. Valid for any text generation task.
metadata:
  category: academic-writing
  tags: [indonesian, unesa, anti-ai, eyd-v, formal-writing]
  version: "1.0.0"
---

<!-- TODO: Incorporate into modules -->
<!-- Style refinements (2026-04-27):
  1. USE English technical terms freely WITHOUT italic formatting.
     Pipeline, framework, threshold, benchmark, baseline, forward/reverse,
     ground truth, source code, deep learning, real-time, case study, etc.
     Only italicize when EYD V strictly requires it for non-technical prose.
  2. LOWER the vocabulary level further — write like a normal undergrad,
     not a polished journal editor. Use "pakai" over "menggunakan",
     "lewat" over "melalui", "supaya" over "agar", "butuh" over "memerlukan",
     "susah" over "sulit", "bisa" over "dapat", "cuma" over "hanya".
  3. KEEP sentence structure direct but not robotic.
     Commas for breathing room, not semicolons everywhere.
  4. REPLACE "makalah" with "paper" in review contexts.
-->

# Indonesian Academic Writing Style

This skill dictates how to write formal, academic, and professional documents in Bahasa Indonesia without sounding like LLMs. It merges the strict technical correctness with the required "de-corporatized," authentic human voice specified by the user's core philosophy.

## When to Use This Skill

- Drafting formal academic papers (Skripsi, Thesis, Jurnal).
- Reviewing or critiquing academic literature in Indonesian.
- Composing professional emails or formal institutional documents.
- DO NOT use for casual slang, fiction, or creative storytelling.

---

## Execution Standards

The execution standards for this skill have been decoupled into specific modules located in the `references/modules/` directory. You must apply the constraints from these modules globally to any text generated under this skill.

### Core Modules
- **[BAHASA](references/modules/BAHASA.md):** EYD V rules, KBBI roots, prefix validation, and foreign word tagging constraints.
- **[DEAI](references/modules/DEAI.md):** Techniques for breaking LLM generation patterns, including syntactic bursts, Pasif Persona, inversions, and sentence rhythm.
- **[ACADEMIC_COMPLIANCE](references/modules/ACADEMIC_COMPLIANCE.md):** Formal logic, eliminating redundancy (Pleonasme), citation standards, and Skripsi-specific structuring.
- **[WORKFLOW](references/modules/WORKFLOW.md):** The integration pipeline and instructions on how to use the L1-L9 validation scripts in `scripts/`.

---

## References & Deep Research Links
The following sources provide the foundational linguistic patterns used to bypass modern AI detection in formal Indonesian:
- **NotebookLM Research Hub:** [UNESA Academic Research Hub](https://notebooklm.google.com/notebook/cd2a70f1-29c5-4acb-bde5-a8af44004af3)
- **EYD V (Tanda Pisah/Em-Dash):** [https://ejaan.kemdikbud.go.id/eyd/tanda-baca/tanda-pisah/](https://ejaan.kemdikbud.go.id/eyd/tanda-baca/tanda-pisah/)
- **Narabahasa (Sentence Inversion):** [https://narabahasa.id/artikel/linguistik-umum/sintaksis/mengenal-inversi-sebagai-konstruksi-kalimat/](https://narabahasa.id/artikel/linguistik-umum/sintaksis/mengenal-inversi-sebagai-konstruksi-kalimat/)
- **Narabahasa (Sentence Variation):** [https://narabahasa.id/bahasa/sintaksis/variasi-kalimat-bahasa-indonesia/](https://narabahasa.id/bahasa/sintaksis/variasi-kalimat-bahasa-indonesia/)
- **Adani et al. (2025 Study):** [Linguistic Features in Indo-AI Detection](https://www.researchgate.net/publication/396199191_Comparative_Analysis_of_High_School_Student_and_AI-Generated_Essays_Using_IndoBERT_and_Linguistic_Features)
- **Jurnal Transformatika (2026 Report):** [Multi-model AI identification system](https://journals.usm.ac.id/index.php/transformatika/article/view/13256)
- **Erafone (Identifying AI Patterns):** [https://erafone.com/artikel/post/ciri-ciri-tulisan-ai-yang-mudah-dikenali](https://erafone.com/artikel/post/ciri-ciri-tulisan-ai-yang-mudah-dikenali)
