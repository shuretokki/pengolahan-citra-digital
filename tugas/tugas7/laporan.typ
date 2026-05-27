#import "../laporan/asp.typ": asp, subfig

#show: asp.with(
  lang: "id",
  type: emph("LAPORAN TUGAS"),
  cover: (
    type-pos: "top",
  ),
  title: "MORFOLOGI CITRA",
  course: "Pengolahan Citra Digital",
  lecturer: (name: "Dr. Ir. Ricky Eka Putra, S.Kom., M.Kom.", id: "0716018704"),
  students: (
    (name: "Tri Rianto Utomo", id: "24051204104"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",
  outlines-attr: (
    depth: 3,
    figures: false,
    tables: false,
    codes: false,
  ),
)

= LATIHAN

#grid(
  columns: 2,
  gutter: 1em,
  subfig(image("assets/dilation.png"), [Dilation], height: 18em),
  subfig(image("assets/erosion.png"), [Erosion], height: 18em),

  subfig(image("assets/closing.png"), [Closing], height: 18em),
  subfig(image("assets/opening.png"), [Opening], height: 18em),
)
