#let banner(
  title: "title-or-project-name",
  subtitle: "subtitle-or-author",
  theme: "light",
) = {
  let is-dark = theme == "dark"
  let bg = if is-dark { rgb("#000000") } else { rgb("#ffffff") }
  let title-fill = if is-dark { rgb("#ffffff") } else { rgb("#1f2328") }
  let subtitle-fill = if is-dark { rgb("#e5e7eb") } else { rgb("#57606a") }
  let glow-img = if is-dark { "glow-dark.png" } else { "glow.png" }

  block(
    width: 100%,
    height: 184pt,
    radius: 24pt,
    fill: bg,
    clip: true,
    stroke: 0.5pt + rgb("#CE2124").lighten(80%),
  )[
    #place(top + left)[
      #image("shapes.png", width: 100%, height: 100%)
    ]

    #place(top + left)[
      #image(glow-img, width: 100%, height: 100%)
    ]

    #place(top + left, dx: 34pt, dy: 30pt)[
      #image("logo.png", width: 36pt)
    ]

    #place(bottom + left, dx: 34pt, dy: -32pt)[
      #stack(
        dir: ttb,
        spacing: 16pt,
        text(size: 22pt, font: "JetBrainsMono NF", weight: "bold", fill: title-fill)[#title],
        text(
          size: 14pt,
          font: "JetBrainsMono NF",
          weight: "medium",
          fill: subtitle-fill,
        )[#subtitle],
      )
    ]
  ]
}
