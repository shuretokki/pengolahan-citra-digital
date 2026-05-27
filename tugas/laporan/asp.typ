#import "asp/defaults.typ" as defaults
#import "asp/layout.typ": layout
#import "asp/style.typ": style
#import "asp/components.typ": components, subfig, zebraw
#import "asp/outlines.typ": outlines
#import "asp/title-page.typ": title-page

#let frontmatter(it) = [#metadata((
  type: "front",
  body: {
    set heading(numbering: none)
    set figure(outlined: false)
    it
  },
)) <asp-matter>]
#let backmatter(it) = [#metadata((
  type: "back",
  body: {
    set figure(outlined: false, caption: none, gap: 0pt)
    it
  },
)) <asp-matter>]

#let asp(
  title: "",
  course: "",
  lecturer: (name: "", id: ""),
  students: (),
  program: "",
  department: "",
  faculty: "",
  university: "",
  year: "",
  logo: "unesa.png",
  bib-file: none,
  lang: "id",
  type: none,
  theme: sys.inputs.at("theme", default: "light"),
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  cover: (:),
  numbering-config: (:),
  typography: (:),
  paragraph: (:),
  outlines-attr: (:),
  headings-attr: (:),
  include-cover: true,
  body,
) = {
  let cover = (
    (
      top: 2cm,
      logo-width: 8cm,
      title-size: 18pt,
      type-pos: "bottom", // "top" or "bottom"
      gap-course-lecturer: 0.2cm,
      gap-lecturer-students: 0.2cm,
    )
      + cover
  )

  let numbering-config = (
    (
      front: auto,
      back: auto,
      back-title: auto,
      lampiran: auto,
      heading: auto,
      align: center,
    )
      + numbering-config
  )

  let typography = (
    (
      font-family: ("Times New Roman", "Liberation Serif"),
      font-size: 12pt,
      caption-size: auto,
      caption-gap: auto,
      table-size: 10pt,
    )
      + typography
  )

  let paragraph = (
    (
      justify: true,
      indent: 1.25cm,
      leading: 1.5em,
      enum-indent: 1.25cm,
      enum-body-indent: 0.5cm,
      list-indent: 1.25cm,
      list-body-indent: 0.5cm,
    )
      + paragraph
  )

  let outlines-attr = (
    (
      depth: 3,
      figures: true,
      tables: true,
      codes: true,
      toc: true,
      toc-title: auto,
      lof-title: auto,
      lot-title: auto,
      loc-title: auto,
    )
      + outlines-attr
  )

  let headings-attr = (
    (
      h1: auto,
      h2: auto,
      h3: auto,
      h4: auto,
    )
      + headings-attr
  )

  let i18n = (
    course: (id: "Mata Kuliah :", en: "Course :"),
    lecturer: (id: "Dosen Pengampu :", en: "Lecturer :"),
    students: (id: "Disusun oleh :", en: "Prepared by :"),
    program: (id: "PROGRAM STUDI", en: "STUDY PROGRAM"),
    faculty: (id: "FAKULTAS", en: "FACULTY"),
    toc: (id: [DAFTAR ISI], en: [TABLE OF CONTENTS]),
    lof: (id: [DAFTAR GAMBAR], en: [LIST OF FIGURES]),
    lot: (id: [DAFTAR TABEL], en: [LIST OF TABLES]),
    loc: (id: [DAFTAR KODE], en: [LIST OF CODES]),
    back: (id: [LAMPIRAN-LAMPIRAN], en: [APPENDICES]),
    lampiran: (id: "Lampiran", en: "Appendix"),
    chapter: (id: "BAB", en: "CHAPTER"),
    code: (id: "Kode", en: "Code"),
    thesis: (id: "SKRIPSI", en: "THESIS"),
    ta: (id: "LAPORAN TUGAS AKHIR", en: "FINAL PROJECT REPORT"),
    practicum: (id: "LAPORAN PRAKTIKUM", en: "PRACTICUM REPORT"),
    report: (id: "LAPORAN AKHIR", en: "FINAL REPORT"),
    proposal: (id: "PROPOSAL PENELITIAN", en: "RESEARCH PROPOSAL"),
    by: (id: "Oleh", en: "By"),
    department: (id: "JURUSAN", en: "DEPARTMENT"),
  )

  let tr(key) = i18n.at(key).at(lang)

  let is-formal = (
    type != none
      and (
        lower(type) in ("skripsi", "ta", "thesis", "proposal")
      )
  )

  let type-label = if type == none { "" } else { type }

  let label-course = tr("course")
  let label-lecturer = tr("lecturer")
  let label-students = tr("students")
  let label-program = tr("program")
  let label-faculty = tr("faculty")
  let label-dept = tr("department")
  let label-by = tr("by")

  let toc-title = if outlines-attr.toc-title != auto { outlines-attr.toc-title } else { tr("toc") }
  let lof-title = if outlines-attr.lof-title != auto { outlines-attr.lof-title } else { tr("lof") }
  let lot-title = if outlines-attr.lot-title != auto { outlines-attr.lot-title } else { tr("lot") }
  let loc-title = if outlines-attr.loc-title != auto { outlines-attr.loc-title } else { tr("loc") }

  let back-title = if numbering-config.back-title != auto { numbering-config.back-title } else { tr("back") }
  let lampiran-label = if numbering-config.lampiran != auto { numbering-config.lampiran } else { tr("lampiran") }
  let chapter-prefix = tr("chapter")
  let code-supplement = tr("code")

  set document(title: title, author: students.map(s => s.name))

  show: layout.with(
    paper: paper,
    margin: margin,
    number-align: numbering-config.align,
  )

  show: style.with(
    font-family: typography.font-family,
    font-size: typography.font-size,
    table-size: typography.table-size,
    lang: lang,
  )

  show: components.with(
    numbering-style: (
      if numbering-config.heading != auto { (heading: numbering-config.heading) } else { (:) }
        + if numbering-config.front != auto { (front: numbering-config.front) } else { (:) }
        + (body: "1")
        + if numbering-config.back != auto { (back: numbering-config.back) } else { (:) }
    ),
    caption: (
      if typography.caption-size != auto { (size: typography.caption-size) } else { (:) }
        + if typography.caption-gap != auto { (gap: typography.caption-gap) } else { (:) }
    ),
    labels: (
      if chapter-prefix != auto { (chapter: chapter-prefix) } else { (:) }
        + if lampiran-label != auto { (appendix: lampiran-label) } else { (:) }
        + if code-supplement != auto { (code: code-supplement) } else { (:) }
    ),
    headings: (
      if headings-attr.h1 != auto { (h1: headings-attr.h1) } else { (:) }
        + if headings-attr.h2 != auto { (h2: headings-attr.h2) } else { (:) }
        + if headings-attr.h3 != auto { (h3: headings-attr.h3) } else { (:) }
        + if headings-attr.h4 != auto { (h4: headings-attr.h4) } else { (:) }
    ),
  )

  let logo-img = if logo != none { image(logo, width: cover.logo-width) } else { none }

  let apply-template(it) = {
    let content = outlines.with(
      front-numbering: if numbering-config.front != auto { numbering-config.front } else { defaults.numbering.front },
      body-numbering: "1",
      back-numbering: if numbering-config.back != auto { numbering-config.back } else { defaults.numbering.back },
      chapter-prefix: chapter-prefix,
      toc-title: toc-title,
      toc-depth: outlines-attr.depth,
      back-title: back-title,
      lampiran-label: lampiran-label,
      list-of-figures: outlines-attr.figures,
      list-of-tables: outlines-attr.tables,
      list-of-codes: outlines-attr.codes,
      toc: outlines-attr.toc,
      lof-title: lof-title,
      lot-title: lot-title,
      loc-title: loc-title,
    )(it)

    if include-cover {
      title-page(
        title: title,
        course: course,
        lecturer: lecturer,
        students: students,
        program: program,
        department: department,
        faculty: faculty,
        university: university,
        year: year,
        logo-image: logo-img,
        type: type,
        type-label: type-label,
        is-formal: is-formal,
        type-pos: cover.type-pos,
        cover-top: cover.top,
        cover-title-size: cover.title-size,
        cover-gap-course-lecturer: cover.gap-course-lecturer,
        cover-gap-lecturer-students: cover.gap-lecturer-students,
        label-course: label-course,
        label-lecturer: label-lecturer,
        label-students: label-students,
        label-program: label-program,
        label-faculty: label-faculty,
        label-dept: label-dept,
        label-by: label-by,
        content,
      )
    } else {
      content
    }
  }

  show: apply-template

  set page(numbering: none)
  set page(footer: context {
    let section = state("asp-section", "front").get()
    let fn = if numbering-config.front != auto { numbering-config.front } else { defaults.numbering.front }
    let bn = "1"
    let backn = if numbering-config.back != auto { numbering-config.back } else { defaults.numbering.back }
    let fmt = if section == "main" {
      bn
    } else if section == "back" and backn == "body" {
      bn
    } else {
      fn
    }

    let n = counter(page).get().first()
    align(numbering-config.align, text(size: typography.font-size)[#std.numbering(fmt, n)])
  })

  set par(
    justify: paragraph.justify,
    first-line-indent: paragraph.indent,
    leading: paragraph.leading,
  )

  set enum(indent: paragraph.enum-indent, body-indent: paragraph.enum-body-indent)
  set list(indent: paragraph.list-indent, body-indent: paragraph.list-body-indent)

  body

  if bib-file != none {
    pagebreak(weak: true)
    let bib-title = if lang == "id" { [DAFTAR PUSTAKA] } else { [BIBLIOGRAPHY] }
    heading(level: 1, numbering: n => "")[#bib-title]
    bibliography(bib-file, title: none, style: "ieee")
  }
}
