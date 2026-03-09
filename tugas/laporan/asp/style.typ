#let style(
  font-family: ("Times New Roman", "Liberation Serif"),
  font-size: 12pt,
  table-size: 10pt,
  lang: "id",
  body
) = {
  set text(font: font-family, size: font-size, lang: lang)

  show link: it => {
    if type(it.dest) == str {
      text(fill: blue.darken(20%), underline(it))
    } else {
      it
    }
  }

  show table.cell: it => [
    #text(size: table-size)[#it]
  ]

  body
}
