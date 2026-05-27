#import "lib/banner/banner.typ": banner
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#let theme = sys.inputs.at("theme", default: "light")
#let accent-color = if theme == "dark" { white } else { black }
#let (bg-color, card-bg, text-color, secondary-color) = if theme == "dark" {
  (rgb("#000000"), rgb("#111111"), rgb("#ffffff"), rgb("#a3a3a3"))
} else {
  (rgb("#ffffff"), rgb("#ffffff"), rgb("#000000"), rgb("#525252"))
}

#set page(fill: none, width: 800pt, height: auto, margin: 40pt)
#set text(fill: text-color, font: "HarmonyOS Sans", size: 14pt)

#import "@preview/beautitled:0.1.0": *

#beautitled-setup(
  style: "creative",
  primary-color: text-color,
  secondary-color: secondary-color,
  accent-color: accent-color,
)
#show: beautitled-init

#import "@preview/zebraw:0.6.1": zebraw
#let banner-stroke = 0.5pt + if theme == "dark" { white.transparentize(80%) } else { black.lighten(80%) }
#let zebraw = zebraw.with(background-color: if theme == "dark" { card-bg.lighten(5%) } else {
  secondary-color.lighten(90%)
})
#show raw.where(block: true): it => block(
  width: 100%,
  radius: 12pt,
  stroke: banner-stroke,
  clip: true,
)[
  #set text(font: "JetBrainsMono NF", size: 12pt)
  #zebraw(it)
]

#v(30pt)

#align(center)[
  #banner(
    title: "pengolahan-citra-digital",
    subtitle: "shuretokki",
    theme: theme,
  )
]

#v(30pt)

#let kbd(txt) = box(
  inset: (x: 6pt, y: 3pt),
  baseline: 20%,
  radius: 6pt,
  fill: if theme == "dark" { bg-color.lighten(10%) } else { secondary-color.lighten(95%) },
  stroke: banner-stroke,
  text(size: 10pt, weight: "bold", font: "JetBrainsMono NF", txt),
)
#grid(
  columns: (1fr, 1.2fr),
  gutter: 40pt,
  [
    == #text(fill: accent-color)[Getting Started]

    #text(size: 11pt)[
      *Prerequisites:* This project relies on #kbd("Nix") for automated environment setup. If not using Nix, ensure #kbd("Meson"), #kbd("Clang"), and #kbd("OpenCV") are installed.
    ]

    #v(5pt)
    ```bash
    # setup build system
    just setup
    ```
    ```bash
    # list all command
    just -l
    ```
    == #text(fill: accent-color)[Optional]
    ```bash
    # use direnv if available
    direnv allow
    ```
    ```bash
    # refresh dependencies
    direnv reload
    ```
  ],
  [
    == #text(fill: accent-color)[Tools]

    #v(6pt)
    #stack(dir: ltr, spacing: 8pt, kbd("Nix"), kbd("C++23"), kbd("Clang"), kbd("Meson"), kbd("OpenCV"))

    == #text(fill: accent-color, weight: "bold")[Progress]
    #v(10pt)

    #let roadmap-item(num, title, status) = {
      let is-done = status == "done"
      let accent = if is-done { text-color } else { secondary-color.lighten(40%) }

      grid(
        columns: (25pt, 1fr, 35pt),
        rows: auto,
        gutter: 12pt,
        inset: (y: 0pt),
        // Number & Line
        stack(dir: ttb, spacing: 5pt, align(center, text(size: 9pt, weight: "black", fill: accent)[#num]), if status
          != "last" {
          align(center, line(angle: 90deg, length: 18pt, stroke: 0.6pt + accent.transparentize(50%)))
        }),
        // Track
        stack(
          dir: ttb,
          spacing: 6pt,
          text(
            size: 10.5pt,
            weight: if is-done { "bold" } else { "regular" },
            fill: if is-done { text-color } else { secondary-color },
          )[#title],
          box(width: 100%, height: 2pt, radius: 2pt, fill: secondary-color.transparentize(92%))[
            #if is-done {
              place(rect(width: 100%, height: 100%, radius: 2pt, fill: text-color))
            } else {
              place(rect(width: 35%, height: 100%, radius: 2pt, fill: secondary-color.transparentize(70%)))
            }
          ],
        ),
        // Badge
        align(right + horizon, if is-done {
          box(fill: text-color, radius: 4pt, inset: (x: 5pt, y: 3pt), text(
            size: 6pt,
            weight: "extrabold",
            fill: bg-color,
          )[DONE])
        } else {
          box(stroke: 0.5pt + secondary-color, radius: 4pt, inset: (x: 5pt, y: 3pt), text(
            size: 6pt,
            weight: "bold",
            fill: secondary-color,
          )[WIP])
        }),
      )
    }

    #block(width: 100%)[
      #roadmap-item("01", "Resolusi & Gray Level", "done")
      #roadmap-item("02", "Point Processing", "done")
      #roadmap-item("03", "Histogram & Spatial Filtering", "done")
      #roadmap-item("04", "-", "last")
    ]
  ],
)

#v(50pt)
#line(length: 100%, stroke: 0.5pt + secondary-color.lighten(50%))
#v(10pt)
#align(center)[
  #text(size: 10pt, fill: secondary-color, style: "italic")[
    *DISCLAIMER*: Images used in this repository are not mine and are used for educational purposes only. All copyrights belong to their respective owners.
  ]
]
