#import "laporan/asp.typ": asp

#show: asp.with(
  include-cover: false,

  title: "JUDUL",
  course: "Mata Kuliah",
  type: "Type",
  lecturer: (name: "Dosen Pengampu ", id: "123"),
  students: (
    (name: "Tri Rianto Utomo", id: "24051204104"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",

  cover: (
    top: 2cm,
    logo-width: 8cm,
    title-size: 18pt,
    type-pos: "bottom",
  ),

  outlines-attr: (
    toc: false,
    figures: false,
    tables: false,
  ),

  bib-file: "ref.bib",
)

#page(flipped: true)[
  // #set align(center + horizon)
  #set text(font: "New Computer Modern Math")
  #set par(justify: false, leading: 0.6em)
  #figure(
    // caption: [],
    table(
      columns: (auto, 2fr, 1.5fr, 1.5fr, 1fr, 2fr, 1.5fr, 1.5fr, 1.5fr),
      align: center + horizon,
      stroke: 0.5pt + gray,
      fill: (x, y) => if y == 0 { luma(230) },
      table.header(
        [*Penulis & Tahun*],
        [*Judul Penelitian*],
        [*Tujuan Penelitian*],
        [*Metodologi*],
        [*Sampel & Data*],
        [*Temuan Utama*],
        [*Kelebihan Penelitian*],
        [*Saran Penelitian Selanjutnya*],
        [*Relevansi dengan Topikmu*],
      ),

      [@ma2026scalingcodingagentsatomic], [Y. Ma _et al_], [C], [D], [E], [F], [G], [H], [I],

      [A], [B], [C], [D], [E], [F], [G], [H], [I],

      [A], [B], [C], [D], [E], [F], [G], [H], [I],

      [A], [B], [C], [D], [E], [F], [G], [H], [I],

      [A], [B], [C], [D], [E], [F], [G], [H], [I],

      [A], [B], [C], [D], [E], [F], [G], [H], [I],
    ),
  )
]