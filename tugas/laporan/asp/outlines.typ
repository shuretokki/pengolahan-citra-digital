#let outlines(
  front-numbering: "i",
  chapter-prefix: "BAB",
  frontmatter: none,
  toc-title: "",
  toc-depth: 3,
  list-of-figures: true,
  list-of-tables: true,
  list-of-codes: true,
  lof-title: "",
  lot-title: "",
  loc-title: "",
  body
) = {
  set page(numbering: front-numbering)
  counter(page).update(1)

  show outline.entry: it => {
    if it.element != none and it.element.func() == figure and it.element.caption != none {
      let loc = it.element.location()
      context {
        let headings = query(heading.where(level: 1).before(loc))
        let ch = if headings.len() > 0 { counter(heading).at(headings.last().location()).first() } else { 0 }
        let fn = counter(figure.where(kind: it.element.kind)).at(loc).first()

        let sup = it.element.supplement
        let cap = it.element.caption.body

        link(loc)[
          #grid(
            columns: (auto, 1fr, auto),
            align: (left, left, right),
            [#sup #ch.#fn #h(0.5em)],
            [#cap #box(width: 1fr, inset: (x: 2pt), repeat[.])],
            [#context {
              let p_num = counter(page).at(loc).first()
              let is_main = state("asp-is-main-body", false).at(loc)
              if is_main { numbering("1", p_num) } else { numbering("i", p_num) }
            }]
          )
        ]
      }
    } else {
      it
    }
  }

  if frontmatter != none {
    frontmatter
    pagebreak(weak: true)
  }

  {
    show outline.entry.where(level: 1): it => {
      let loc = it.element.location()

      v(0.5em, weak: true)
      text(weight: "bold")[
        #link(loc)[
          #grid(
            columns: (auto, 1fr, auto),
            align: (left, left, right),
            [
              #if it.element.numbering != none {
                let roman = context numbering("I", counter(heading).at(loc).first())
                [#chapter-prefix #roman #h(0em)]
              }#it.element.body
            ],
            [#box(width: 1fr, inset: (x: 2pt), repeat[.])],
            [#context {
              let p_num = counter(page).at(loc).first()
              let is_main = state("asp-is-main-body", false).at(loc)
              if is_main { numbering("1", p_num) } else { numbering("i", p_num) }
            }]
          )
        ]
      ]
    }

    heading(level: 1, numbering: none)[#toc-title]
    outline(
      title: none,
      indent: auto,
      depth: toc-depth,
    )
  }

  context {
    let figs = query(figure.where(kind: image))
    if list-of-figures and figs.len() > 0 {
      pagebreak(weak: true)
      heading(level: 1, numbering: none)[#lof-title]
      outline(
        title: none,
        target: figure.where(kind: image),
      )
    }
  }

  context {
    let tabs = query(figure.where(kind: table))
    if list-of-tables and tabs.len() > 0 {
      pagebreak(weak: true)
      heading(level: 1, numbering: none)[#lot-title]
      outline(
        title: none,
        target: figure.where(kind: table),
      )
    }
  }

  context {
    let codes = query(figure.where(kind: raw))
    if list-of-codes and codes.len() > 0 {
      pagebreak(weak: true)
      heading(level: 1, numbering: none)[#loc-title]
      outline(
        title: none,
        target: figure.where(kind: raw),
      )
    }
  }

  body
}
