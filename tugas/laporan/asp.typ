#import "asp/layout.typ": layout
#import "asp/style.typ": style
#import "asp/components.typ": components, subfig
#import "asp/outlines.typ": outlines
#import "asp/title-page.typ": title-page

#let asp(
  title: "",
  course: "",
  lecturer: "",
  nidn: "",
  students: (),
  program: "",
  faculty: "",
  university: "",
  year: "",
  logo: "unesa.png",
  label-course: auto,
  label-lecturer: auto,
  label-students: auto,
  label-program: auto,
  label-faculty: auto,
  bib-file: none,
  frontmatter: none,

  paper: "a4",
  margin-top: 2.5cm,
  margin-bottom: 2.5cm,
  margin-left: 2.5cm,
  margin-right: 2.5cm,
  front-numbering: "i",
  body-numbering: "1",
  number-align: center,

  font-family: ("Times New Roman", "Liberation Serif"),
  font-size: 12pt,
  caption-size: 10pt,
  caption-gap: 0.65em,
  table-size: 10pt,
  lang: "id",

  par-justify: true,
  par-indent: 1.25cm,
  par-leading: 1.5em,

  enum-indent: 1.25cm,
  enum-body-indent: 0.5cm,
  list-indent: 1.25cm,
  list-body-indent: 0.5cm,

  heading-numbering: "1.1.",

  h1-size: 14pt,
  h1-above: 36pt,
  h1-below: 24pt,
  h1-pagebreak: true,
  h1-align: center,

  h2-size: 12pt,
  h2-above: 24pt,
  h2-below: 18pt,
  h2-indent: 0cm,

  h3-size: 12pt,
  h3-above: 14pt,
  h3-below: 18pt,
  h3-indent: 0cm,

  h4-size: 12pt,
  h4-above: 12pt,
  h4-below: 18pt,
  h4-indent: 0cm,

  cover-top: 2cm,
  cover-logo-width: 8cm,
  cover-gap-course-lecturer: 0.2cm,
  cover-gap-lecturer-students: 0.2cm,
  cover-title-size: 18pt,

  toc-title: auto,
  toc-depth: 3,
  list-of-figures: true,
  list-of-tables: true,
  list-of-codes: true,
  lof-title: auto,
  lot-title: auto,
  loc-title: auto,

  body

) = {
  let loc(val, id, en) = if val != auto { val } else if lang == "id" { id } else { en }

  let label-course = loc(label-course, "Mata Kuliah :", "Course :")
  let label-lecturer = loc(label-lecturer, "Dosen Pengampu :", "Lecturer :")
  let label-students = loc(label-students, "Disusun oleh :", "Prepared by :")
  let label-program = loc(label-program, "PROGRAM STUDI", "STUDY PROGRAM")
  let label-faculty = loc(label-faculty, "FAKULTAS", "FACULTY")
  let toc-title = loc(toc-title, [DAFTAR ISI], [TABLE OF CONTENTS])
  let lof-title = loc(lof-title, [DAFTAR GAMBAR], [LIST OF FIGURES])
  let lot-title = loc(lot-title, [DAFTAR TABEL], [LIST OF TABLES])
  let loc-title = loc(loc-title, [DAFTAR KODE], [LIST OF CODES])
  let chapter-prefix = if lang == "id" { "BAB" } else { "CHAPTER" }
  let code-supplement = if lang == "id" { "Kode" } else { "Code" }

  set document(title: title, author: students.map(s => s.name))

  show: layout.with(
    paper: paper,
    margin-top: margin-top,
    margin-bottom: margin-bottom,
    margin-left: margin-left,
    margin-right: margin-right,
    number-align: number-align,
  )

  show: style.with(
    font-family: font-family,
    font-size: font-size,
    table-size: table-size,
    lang: lang,
  )

  show: components.with(
    heading-numbering: heading-numbering,
    caption-size: caption-size,
    caption-gap: caption-gap,
    chapter-prefix: chapter-prefix,
    code-supplement: code-supplement,
    h1-size: h1-size, h1-above: h1-above, h1-below: h1-below,
    h1-pagebreak: h1-pagebreak, h1-align: h1-align,
    h2-size: h2-size, h2-above: h2-above, h2-below: h2-below, h2-indent: h2-indent,
    h3-size: h3-size, h3-above: h3-above, h3-below: h3-below, h3-indent: h3-indent,
    h4-size: h4-size, h4-above: h4-above, h4-below: h4-below, h4-indent: h4-indent,
  )

  let logo-img = if logo != none { image(logo, width: cover-logo-width) } else { none }

  show: title-page.with(
    title: title,
    course: course,
    lecturer: lecturer,
    nidn: nidn,
    students: students,
    program: program,
    faculty: faculty,
    university: university,
    year: year,
    logo-image: logo-img,
    cover-top: cover-top,
    cover-title-size: cover-title-size,
    cover-gap-course-lecturer: cover-gap-course-lecturer,
    cover-gap-lecturer-students: cover-gap-lecturer-students,
    label-course: label-course,
    label-lecturer: label-lecturer,
    label-students: label-students,
    label-program: label-program,
    label-faculty: label-faculty,
  )

  show: outlines.with(
    front-numbering: front-numbering,
    frontmatter: frontmatter,
    chapter-prefix: chapter-prefix,
    toc-title: toc-title,
    toc-depth: toc-depth,
    list-of-figures: list-of-figures,
    list-of-tables: list-of-tables,
    list-of-codes: list-of-codes,
    lof-title: lof-title,
    lot-title: lot-title,
    loc-title: loc-title,
  )

  set page(numbering: none)
  set page(footer: context {
    let mode = state("asp-is-main-body", false).get()
    let fmt = if mode { body-numbering } else { front-numbering }
    let n = counter(page).get().first()
    align(number-align, text(size: font-size)[#numbering(fmt, n)])
  })

  set par(
    justify: par-justify,
    first-line-indent: par-indent,
    leading: par-leading,
  )

  set enum(indent: enum-indent, body-indent: enum-body-indent)
  set list(indent: list-indent, body-indent: list-body-indent)

  body

  if bib-file != none {
    pagebreak(weak: true)
    let bib-title = if lang == "id" { [DAFTAR PUSTAKA] } else { [BIBLIOGRAPHY] }
    heading(level: 1, numbering: n => "")[#bib-title]
    bibliography(bib-file, title: none, style: "ieee")
  }
}
