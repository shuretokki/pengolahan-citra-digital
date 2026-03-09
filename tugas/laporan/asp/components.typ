#let components(
  heading-numbering: "1.1.",
  caption-size: 10pt,
  caption-gap: 0.65em,
  chapter-prefix: "CHAPTER",
  code-supplement: "Code",
  h1-size: 16pt,
  h1-above: 24pt,
  h1-below: 18pt,
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
  body
) = {
  set heading(numbering: heading-numbering)
  set figure(gap: caption-gap, placement: none)

  show figure.caption: it => [
    #text(size: caption-size)[
      *#it.supplement #context [#{it.counter.display(it.numbering)}:]* #it.body
    ]
  ]

  set figure(numbering: n => context [#counter(heading).get().first().#n])
  set math.equation(numbering: n => context [(#counter(heading).get().first().#n)], block: true)

  show math.equation.where(block: true): set block(above: 1.5em, below: 2.5em)
  set figure(gap: 1em)

  show figure.where(kind: raw): set figure(supplement: [#code-supplement])

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

  show raw.where(block: true): it => block(
    fill: luma(240),
    inset: 8pt,
    stroke: luma(200),
    radius: 0pt,
    width: 100%,
    text(
      font: ("JetBrainsMonoNL NF"),
      size: 10pt)[#it]
  )

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

      let reset-trigger = if it.numbering != none [
        #state("asp-is-main-body", false).update(true)
        #context {
          if state("asp-page-reset", false).get() == false [
            #counter(page).update(1)
            #state("asp-page-reset", false).update(true)
          ]
        }
      ]

      let num = if it.numbering != none {
        counter(heading).display("I")
      } else {
        none
      }

      let content = align(h1-align)[
        #reset-trigger
        #v(h1-above)
        #text(size: h1-size)[
          #if num != none {
            [#chapter-prefix #num \ ]
          }
          #it.body
        ]
        #v(h1-below)
      ]
      if h1-pagebreak { pagebreak(weak: true) + content } else { content }
    } else if it.level == 2 {
      v(h2-above, weak: true)
      text(size: h2-size)[
        #h(h2-indent)#number.trim() #it.body
      ]
      v(h2-below, weak: true)
    } else if it.level == 3 {
      v(h3-above, weak: true)
      text(size: h3-size)[
        #h(h3-indent)#number.trim() #it.body
      ]
      v(h3-below, weak: true)
    } else {
      v(h4-above, weak: true)
      text(size: h4-size)[
        #h(h4-indent)#it.body
      ]
      v(h4-below, weak: true)
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