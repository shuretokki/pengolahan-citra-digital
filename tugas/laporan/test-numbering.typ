#import "asp.typ": asp, backmatter, frontmatter, zebraw


#show: asp.with(
  title: "Integrated Stress Test: Complexity Redefineds",
  course: "Digital Image Processing Stress Test",
  type: "LAPORAN PRAKTIKUM",
  lecturer: (
    name: "Prof. Dr. Edge Case",
    id: "123456789",
  ),
  students: (
    (name: "Human Tester", id: "001"),
    // (name: "AI Collaborator", id: "002"),
  ),
  program: "Informatics Engineering",
  department: "Teknik Informatika",
  faculty: "Faculty of Engineering",
  university: "Universitas Negeri Surabaya",
  year: "2026",
  logo: "unesa.png",
  bib-file: "test.bib",
  lang: "id",

  cover: (
    top: 2cm,
    logo-width: 8cm,
    title-size: 18pt,
    type-pos: "bottom",
  ),

  numbering-config: (
    front: auto,
    back: "body",
    align: center,
  ),

  typography: (
    font-family: ("Times New Roman", "Liberation Serif"),
    font-size: 12pt,
    caption-size: 10pt,
    table-size: 10pt,
  ),

  paragraph: (
    justify: true,
    indent: 1.25cm,
    leading: 1.5em,
  ),

  outlines-attr: (
    depth: 3,
    figures: true,
    tables: true,
    codes: true,
  ),

  headings-attr: (
    h1: auto,
  ),

  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
)


#frontmatter[
  = ABSTRACT <abs_heading>
  This document serves as a high-complexity stress test for the `asp` Typst template. It attempts to trigger every single layout and numbering logic branch.

  #zebraw(
    highlight-lines: (2,), // Highlights line 2
    ```rust
    fn main() {
        println!("This line is highlighted!");
    }
    ```,
  ),

  #rect(width: 50%, height: 2cm, fill: gray)

]

#frontmatter[
  = DEDICATION
  This section tests multiple `#frontmatter` calls.
]

= The Core Content <ch1>
Body page 1. This chapter tests cross-references to all other document sections.

- See the abstract on #lower[@abs_heading].
- Check out the appendix details in @l1.
- Look at the circle in @back_circle.
- Theoretical math in @eq_core.
- Citation test: @test. #footnote[Testing a footnote in the main body.]

$ E = m c^2 $ <eq_core>

#figure(
  rect(width: 30%, height: 3cm, fill: blue),
  caption: [A blue square in Chapter 1],
) <fig_body_1>

#pagebreak()

= Nested Structures
Testing deep nesting and how it affects the figure resets. #footnote[Another footnote here to check numbering continuity.]

== Subsection 2.1
#lorem(20)

=== Sub-subsection 2.1.1
#lorem(20)

#figure(
  table(
    columns: (1fr, 1fr),
    [A], [B],
    [C], [D],
  ),
  caption: [First table in Chapter 2],
) <tab_body_1>

#pagebreak()

= Bab 3: Massive Content
Testing how the TOC and Outlines handle page overflow.

#for i in range(20) [
  == Sub-item #i
  #lorem(50)
  #if i == 10 [
    #figure(
      circle(radius: 0.5cm, fill: red),
      caption: [Red circle in a loop],
    )
  ]
]

#backmatter[
  = Daftar Lomba yang dapat Disetarakan dengan Tugas Akhir <l1>
  #figure(
    rect(width: 40%, height: 2cm, fill: green),
  )
]

#backmatter[
  = Formulir Permohonan Rekognisi Artikel Jurnal Ilmiah sebagai Pengganti Tugas Akhir <l2>

  #figure(
    circle(radius: 1cm, fill: purple),
  ) <back_circle>

  #figure(
    ```rust
    fn main() {
        println!("Stress test success!");
    }
    ```,
  )

  #figure(
    table(
      columns: 2,
      [Key], [Value],
      [Status], [Edge Case],
      [Complexity], [High],
    ),
  )
]
