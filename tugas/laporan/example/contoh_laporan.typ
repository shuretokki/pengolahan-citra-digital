#import "../asgReport.typ": asgReport

#show: asgReport.with(
  title: "PANDUAN REFERENSI TYPST",
  // course: "Digital Image Processing",
  // lecturer: "Dr. Ricky Eka Putra, S.Kom., M.Kom.",
  // nidn: "198701162018031001",
  students: (
    (name: "Tri Rianto Utomo", id: "24051204104"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",
)

#include "bab1.typ"
#include "bab2.typ"
#include "bab3.typ"
#include "bab4.typ"
#bibliography("refs.bib", style: "ieee", title: [DAFTAR PUSTAKA])
