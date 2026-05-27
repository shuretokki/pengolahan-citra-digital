#import "@preview/zebraw:0.6.1": zebraw
#import "defaults.typ"
#let components(
  numbering-style: (:),
  caption: (:),
  labels: (:),
  code: (:),
  headings: (:),
  body,
) = {
  let numbering-style = defaults.numbering + numbering-style
  let caption = defaults.caption + caption
  let labels = defaults.labels + labels
  let code = defaults.code + code
  let headings = defaults.headings + headings
  set heading(numbering: numbering-style.heading)
  set figure(gap: caption.gap, placement: none)

  show figure.caption: it => [
    #text(size: caption.size)[
      *#it.supplement #context [#{ it.counter.display(it.numbering) }:]* #it.body
    ]
  ]

  show ref: it => {
    if it.element == none { return it }
    let el = it.element
    if el.func() == heading and el.numbering == none {
      return context {
        let loc = el.location()
        let n = counter(page).at(loc).first()
        let section = state("asp-section", "front").at(loc)
        let is_main_fmt = if section == "main" { true } else if section == "back" {
          numbering-style.back == "body"
        } else {
          false
        }

        let fmt = if is_main_fmt { numbering-style.body } else { numbering-style.front }
        let body = if it.supplement not in (none, auto) { it.supplement } else { el.body }
        link(loc)[#body (halaman #numbering(fmt, n))]
      }
    }
    it
  }

  set figure(numbering: n => context {
    let is_main = state("asp-is-main-body", false).get()
    if is_main {
      let ch = counter(heading).get().first()
      [#ch.#n]
    } else {
      [#n]
    }
  })

  set math.equation(numbering: n => context [(#counter(heading).get().first().#n)], block: true)

  show math.equation.where(block: true): set block(above: 1.5em, below: 2.5em)
  set figure(gap: 1em)

  show figure.where(kind: raw): set figure(supplement: [#labels.code])

  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    set align(center)
    it
  }
  show figure.where(kind: raw): it => {
    set figure.caption(position: top)
    set align(left)
    it
  }
  show figure.where(kind: image): it => {
    set align(center)
    it
  }

  show: zebraw.with(background-color: code.fill)
  show raw: set text(font: code.font, size: code.size)

  show heading: it => {
    set text(weight: "bold")
    set par(first-line-indent: 0pt)

    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    if it.level == 1 {
      counter(figure.where(kind: image)).update(0)
      counter(figure.where(kind: table)).update(0)
      counter(figure.where(kind: raw)).update(0)
      counter(math.equation).update(0)

      context {
        let section = state("asp-section", "front").get()

        let num = if it.numbering != none {
          if section == "back" {
            counter(heading).display("1")
          } else if type(it.numbering) == str and it.numbering.contains("1") {
            counter(heading).display("I")
          } else {
            counter(heading).display(it.numbering)
          }
        } else {
          none
        }

        let content = [
          #align(if section == "back" and num != none { left } else { center })[
            #v(headings.h1.above)
            #text(size: headings.h1.size, weight: "bold")[
              #if num != none {
                if section == "back" {
                  [#labels.appendix #num. #text(weight: "regular")[#upper(it.body)]]
                } else {
                  [#labels.chapter #num \ #upper(it.body)]
                }
              } else {
                upper(it.body)
              }
            ]
            #v(headings.h1.below)
          ]
        ]

        let should_break = if headings.h1.pagebreak {
          if section == "back" {
            if it.numbering == none {
              true
            } else {
              counter(heading).get().first() > 1
            }
          } else {
            true
          }
        } else {
          false
        }

        if should_break {
          pagebreak(weak: true) + content
        } else {
          content
        }
      }
    } else if it.level == 2 {
      v(headings.h2.above, weak: true)
      text(size: headings.h2.size)[
        #h(headings.h2.indent)#number.trim() #it.body
      ]
      v(headings.h2.below, weak: true)
    } else if it.level == 3 {
      v(headings.h3.above, weak: true)
      text(size: headings.h3.size)[
        #h(headings.h3.indent)#number.trim() #it.body
      ]
      v(headings.h3.below, weak: true)
    } else {
      v(headings.h4.above, weak: true)
      text(size: headings.h4.size)[
        #h(headings.h4.indent)#it.body
      ]
      v(headings.h4.below, weak: true)
    }
  }

  body
}

#let subfig(img, cap, width: 100%, height: auto, fit: "cover") = align(center)[
  #box(clip: true, width: width, height: height)[
    #if type(img) == str {
      image(img, width: width, height: height, fit: fit)
    } else {
      img
    }
  ]
  #v(0em)
  #text(size: 10pt)[#cap]
]
