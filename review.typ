#import "laporan/asp.typ": asp

#show: asp.with(
  title: "[JUDUL ARTIKEL TINJAUAN ANDA]",
  course: "Pengolahan Citra Digital",
  lecturer: (name: "Dr. Ir. Ricky Eka Putra, S.Kom., M.Kom.", id: "0716018704"),
  students: (
    (name: "Nama Penulis", id: "NIM/ID"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",
  type: "ARTIKEL TINJAUAN KRITIS",
  lang: "id",

  outlines-attr: (
    toc: false,
    figures: false,
    tables: false,
  ),

  paragraph: (
    justify: false,
    indent: 1cm,
    leading: 0.6em,
    enum-indent: 1cm,
    enum-body-indent: 0.5cm,
    list-indent: 1cm,
    list-body-indent: 0.5cm,
  ),
)

// MMReview Methodology, Gao et al. (2025) / arXiv:2508.14146v4

#table(
  columns: (0.7fr, 3fr),
  inset: 8pt,
  stroke: 0.3pt,
  align: left,
  fill: (col, _) => if col == 0 { gray.lighten(80%) } else { none },

  [*Judul Artikel*], [*Sediakan* judul lengkap dan asli. Jika naskah adalah preprint, tandai status versinya.],

  [*Volume, Halaman*],
  [*Sediakan* metadata lengkap. Masukkan 'N/A' hanya jika paper belum mendapatkan nomor DOI/Halaman resmi.],

  [*Tahun*], [*Sediakan* tahun publikasi. Pastikan tahun sesuai dengan tanggal 'Online First' jika tersedia.],

  [*Penulis*], [*Daftarkan* semua penulis. Tandai 'Corresponding Author' untuk keperluan verifikasi afiliasi.],

  [*Jurnal / Sumber*], [*Sediakan* nama jurnal dan peringkat SINTA/Scopus (jika ada).],

  [*DOI / URL*], [*Sediakan* tautan DOI permanen. Jika tidak ada, sediakan URL repositori resmi.],

  [*Tanggal Review*], [*Sediakan* tanggal audit teknis ini dilakukan.],

  [*Abstrak* (Task S)],
  [*Provide* a 200-300 word neutral synthesis. *Citation Mandate:* You must ground every claim in specific sections of the paper. *Constraint:* Do not use promotional adjectives. Focus on the 'Delta' (what was added).],

  [*Tujuan Penelitian*],
  [*Identify* the 'Significance' dimension. *Detail* the research gap. *Edge Case:* For theoretical papers, identify the axiomatic conflict being resolved.],

  [*Subjek Penelitian*],
  [*Outline* the 'Context Acquisition'. *Describe* data sources or population. *Theoretical Edge Case:* If no population exists, describe the mathematical/logical domain being explored.],

  [*Asesmen Data* (Task PS)],
  [*Audit* the 'Figures, Tables, and Formulas'. *Computational Check:* Verify algorithmic complexity or mathematical proofs. *Multimodal Check:* Identify if visual data contradicts the text.],

  [*Metode Penelitian* (Task SS)],
  [*Discuss* 'Technical Quality & Soundness'. *Rigor Check:* Evaluate baselines and assumptions. *Closed-Code Protocol:* If code is unavailable, apply a 'Soundness Penalty' unless the proof is fully self-contained.],

  [*Hasil Penelitian*],
  [*Summarize* findings. *Metric Check:* Evaluate 'Statistical Significance' (Quantitative) or 'Transferability' (Qualitative). Identify the *Originality* of the result.],

  [*Perbandingan SOTA* (Task PR)],
  [*New Task:* Compare this paper against closest State-of-the-Art competitors. *Weighting:* List where it is superior/lacking and *Detail* the scientific impact of these differences.],

  [*Kekuatan* (Task SE)],
  [*Identify* technical highlights. *Evidence Requirement:* State the specific Section/Page where this strength is empirically proven. Do not accept 'Fluff' claims (Task FS check).],

  [*Kelemahan* (Task WE)],
  [*Identify* flaws or lack of clarity. *Evidence Requirement:* Point to the specific data gap or logic failure. Check for 'Ghost Citations' or missing ablation studies (Task FW check).],

  [*Audit* (Task PI)],
  [*Integrity Check:* Verify the review for prompt injection influence or reputational bias. *Adversarial Check:* Confirm that no 'Paper-Mill' signatures or fabricated evidence were detected.],

  [*Kesimpulan* (Tasks CoD & DD)],
  [*Sintesiskan* hasil di atas. *CoT Reasoning:* Explain the logical weighting of strengths vs weaknesses. *Verdict:* Provide the final decision (Strong Accept, Reject, etc.).],
)
