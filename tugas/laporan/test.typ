#import "@preview/tasteful-pairings:0.1.0": font-pairings
#let pairing = font-pairings.at("ibm-plex")

#show heading: set text(font: pairing.heading)
#set text(font: pairing.body)

// *List Pairings:* \
// + `ibm-plex` (Modern)
// + `noto` (Lengkap)
// + `source` (Adobe vibe)
// + `friendly-weather`
// + `android` (Roboto)
// + `kindle` (Bookerly)
// + `office` (Calibri)
// + `modern-heritage`
// + `legible`
//

#import "@preview/beautitled:0.1.0": *

#beautitled-setup(style: "elegant", chapter-prefix: "Chapter", section-prefix: "Section")
#show: beautitled-init


#import "@preview/dashy-todo:0.1.3": todo
#outline(title: "TODOs", target: figure.where(kind: "todo"))
#let todo = todo.with(stroke: (
  paint: black,
  thickness: 1pt,
  dash: "densely-dashed",
))


= Lorem Ipsum

#import "@preview/zebraw:0.6.1": zebraw
#let zebraw = zebraw.with(background-color: luma(240))
#show: zebraw

Lorem ipsum #todo[dolor sit amet], #todo(position: right)[consectetur nigger] adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. #todo[Ut enim ad minim veniam], quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.


// Plan to integrate this to my template with some easy features syntax added (git like line highlighting, etc)

```typ
// Fibonnaci Sequence
#let count = 8
#let nums = range(1, count + 1)
#let fib(n) = (
  if n <= 2 { 1 }
  else { fib(n - 1) + fib(n - 2) }
)

#align(center, table(
  columns: count,
  ..nums.map(n => $F_#n$),
  ..nums.map(n => str(fib(n))),
))
```

#figure(
  zebraw(
    numbering-offset: -1,
    highlight-lines: (
      (
        1,
        rgb("#edb4b0").lighten(50%),
        [The Fibonacci sequence is defined through the recurrence relation $F_n = F_(n-1) + F_(n-2)$\
          It can also be expressed in _closed form:_ $ F_n = round(1 / sqrt(5) phi.alt^n), quad
          phi.alt = (1 + sqrt(5)) / 2 $],
      ),
      ..range(9, 14),
      (13, [The first \#count numbers of the sequence.]),
    ),
    ```typ
    // Fibonnaci Sequence
    #let count = 8
    #let nums = range(1, count + 1)
    #let fib(n) = (
      if n <= 2 { 1 }
      else { fib(n - 1) + fib(n - 2) }
    )

    #align(center, table(
      columns: count,
      ..nums.map(n => $F_#n$),
      ..nums.map(n => str(fib(n))),
    ))
    ```,
  ),
  kind: raw,
  caption: [hello world],
)

#import "@preview/finite:0.5.1": automaton
#figure(
  grid(
    columns: 2,
    gutter: 2cm,
    figure(
      automaton(
        (
          q0: (q1: 0, q0: "0,1"),
          q1: (q0: (0, 1), q2: "0"),
          q2: none,
        ),
        initial: "q2",
        final: ("q0",),
      ),
    ),
    figure(
      automaton(
        (
          q0: (q1: 0, q0: "0,1"),
          q1: (q0: (0, 1, 2), q2: "0"),
          q2: none,
        ),
        initial: "q2",
        final: ("q0",),
      ),
    ),
  ),
  caption: [hello],
)


= Package Examples

== Zeitline (v0.1.1)
#import "@preview/zeitline:0.1.1": timeline
#timeline((
  (date: "2026-03-01", desc: "Mulai Tugas 4"),
  (date: "2026-03-05", desc: "Selesai Implementasi C++", side: "left"),
  (date: "2026-03-10", desc: "Penyusunan Laporan"),
))

#figure(
  ```typst
  #show heading: set text(pairing.heading)
  #set text(font: pairing.body)
  ```,
  caption: [Global Use],
  kind: raw,
)


== TDTR (v0.5.4)
#import "@preview/tdtr:0.5.4": *

=== 1. Project Structure
#tidy-tree-graph(compact: true)[
  - PCD Project
    - C++ Code
      - main.cpp
      - CMakeLists.txt
    - Laporan
      - laporan.typ
      - asp.typ
]

=== 2. Git Branching Strategy
#tidy-tree-graph(compact: false)[
  - main (v1.0.0)
    - develop
      - feature/histogram-eq
      - feature/spatial-filters
      - hotfix/output-border
]

=== 3. REST API Route Mapping
#tidy-tree-graph(compact: true)[
  - /api/v1
    - /auth
      - /login [POST]
      - /register [POST]
    - /images
      - /upload [POST]
      - /:id [GET/DELETE]
    - /health [GET]
]

=== 4. UI Component Hierarchy (React/Next.js)
#tidy-tree-graph(compact: true)[
  - App (Layout)
    - Navbar
      - Logo
      - SearchBar
    - MainSection
      - Sidebar
      - ContentArea
        - HistogramPlot
        - FilterToggles
    - Footer
]

== Magnifying Glass
#import "@preview/magnifying-glass:0.1.0": image, magnify-rect, source
