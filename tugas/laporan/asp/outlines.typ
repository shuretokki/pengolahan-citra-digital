#let outlines(
  front-numbering: "i",
  body-numbering: "1",
  back-numbering: "front",
  chapter-prefix: "BAB",
  toc-title: "",
  toc-depth: 3,
  list-of-figures: true,
  list-of-tables: true,
  list-of-codes: true,
  lof-title: "",
  lot-title: "",
  loc-title: "",
  toc: true,
  back-title: [LAMPIRAN-LAMPIRAN],
  lampiran-label: "Lampiran",
  body,
) = {
  state("asp-section").update("front")
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
            columns: (1fr, auto),
            column-gutter: 0.5em,
            align: (left, bottom),
            [
              #sup #ch.#fn #h(0.5em) #cap
              #box(width: 1fr, inset: (x: 2pt), repeat[.])
            ],
            [#context {
              let p_num = counter(page).at(loc).first()
              let section = state("asp-section").at(loc)
              let is_main_fmt = if section == "main" { true } else if section == "back" {
                back-numbering == "body"
              } else { false }
              let fmt = if is_main_fmt { body-numbering } else { front-numbering }
              numbering(fmt, p_num)
            }],
          )
        ]
      }
    } else {
      it
    }
  }

  [#metadata(none) <asp-section-front>]
  context {
    let matters = query(<asp-matter>)
    let front_blocks = matters.filter(m => m.value.type == "front").map(m => m.value.body)

    for block in front_blocks {
      block
      pagebreak(weak: true)
    }
  }

  {
    set par(leading: 0.65em)
    show outline.entry.where(level: 1): it => {
      let loc = it.element.location()

      v(0.5em, weak: true)
      text(weight: "bold")[
        #link(loc)[
          #grid(
            columns: (1fr, auto),
            column-gutter: 0.5em,
            align: (left, bottom),
            [
              #if it.element.numbering != none {
                context {
                  let section = state("asp-section").at(loc)
                  let val = counter(heading).at(loc).first()
                  if section == "back" {
                    [#lampiran-label #val. ]
                  } else {
                    let roman = numbering("I", val)
                    [#chapter-prefix #roman ]
                  }
                }
              }#it.element.body
              #box(width: 1fr, inset: (x: 2pt), repeat[.])
            ],
            [#context {
              let p_num = counter(page).at(loc).first()
              let section = state("asp-section").at(loc)
              let is_main_fmt = if section == "main" { true } else if section == "back" {
                back-numbering == "body"
              } else { false }
              let fmt = if is_main_fmt { body-numbering } else { front-numbering }
              numbering(fmt, p_num)
            }],
          )
        ]
      ]
    }

    if toc == true {
      heading(level: 1, numbering: none)[#toc-title]
      outline(
        title: none,
        indent: auto,
        depth: toc-depth,
      )
    }
  }


  context {
    let figs = query(figure.where(kind: image))
    if list-of-figures and figs.len() > 0 {
      pagebreak(weak: true)
      heading(level: 1, numbering: none)[#lof-title]
      set par(leading: 0.65em)
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
      set par(leading: 0.65em)
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
      set par(leading: 0.65em)
      outline(
        title: none,
        target: figure.where(kind: raw),
      )
    }
  }

  // start main
  state("asp-section").update("main")
  [#metadata(none) <asp-marker-front-end>]
  pagebreak(weak: true)
  state("asp-is-main-body", false).update(true)
  counter(page).update(1)
  [#metadata(none) <asp-section-body>]
  body

  // start backmatter
  context {
    let matters = query(<asp-matter>)
    let back_blocks = matters.filter(m => m.value.type == "back").map(m => m.value.body)

    if back_blocks.len() > 0 {
      pagebreak(weak: true)

      if back-numbering == "front" {
        let end_marker = query(<asp-marker-front-end>).first()
        let val = counter(page).at(end_marker.location()).first()
        counter(page).update(val + 1)
      }

      state("asp-is-main-body", false).update(false)
      state("asp-section").update("back")
      [#metadata(none) <asp-section-back>]
      heading(level: 1, numbering: none, outlined: true)[#back-title]
      counter(heading).update(0)

      for block in back_blocks {
        block
        pagebreak(weak: true)
      }
    }
  }

  context {
    let q_front = query(<asp-section-front>)
    let q_body = query(<asp-section-body>)
    let q_back = query(<asp-section-back>)

    let get_info(q, fmt_style) = if q.len() > 0 {
      let loc = q.first().location()
      let section = state("asp-section").at(loc)
      let is_main_style = if section == "main" { true } else if section == "back" { back-numbering == "body" } else {
        false
      }
      let active_fmt = if is_main_style { body-numbering } else { front-numbering }
      (
        idx: counter(page).at(loc).first(),
        display: numbering(active_fmt, counter(page).at(loc).first()),
      )
    } else { none }

    [#metadata((
      front: get_info(q_front, "front"),
      body: get_info(q_body, "body"),
      back: get_info(q_back, "back"),
    )) <results>]
  }
}
