#let title-page(
  title: "",
  course: "",
  lecturer: (name: "", id: ""),
  students: (),
  program: "",
  department: "",
  faculty: "",
  university: "",
  year: "",
  logo-image: none,
  cover-top: 2cm,
  cover-title-size: 18pt,
  cover-gap-course-lecturer: 0.2cm,
  cover-gap-lecturer-students: 0.2cm,
  label-course: "",
  label-lecturer: "",
  label-students: "",
  label-program: "",
  label-faculty: "",
  label-dept: "",
  label-by: "",
  type: "",
  type-label: "",
  type-pos: "bottom",
  is-formal: false,
  body,
) = {
  let title-text = text(size: cover-title-size, weight: "bold")[#upper(title)]
  let type-text = text(size: 14pt, weight: "bold", style: if is-formal { "italic" } else { "normal" })[#upper(
    type-label,
  )]

  page(numbering: none)[
    #set text(font: ("Times New Roman", "Liberation Serif"))
    #align(center)[
      #v(cover-top)

      #if type-pos == "top" [
        #if type-label != "" { type-text + v(0.1cm) }
        #title-text
      ] else [
        #title-text
        #if type-label != "" { v(0.1cm) + type-text }
      ]

      #v(1fr)

      #if logo-image != none { logo-image }

      #v(1fr)

      #if course != "" [
        #label-course\
        #text(weight: "bold")[#course]
        #v(cover-gap-course-lecturer)
      ]

      #if lecturer.name != "" [
        #label-lecturer\
        #text(weight: "bold", style: "italic", underline(lecturer.name))\
        #if lecturer.id != "" [#lecturer.id]
        #v(cover-gap-lecturer-students)
      ]

      #if is-formal [
        #text(size: 12pt)[#label-by] \
        #v(0.2cm)
        #if students.len() > 0 {
          let s = students.first()
          text(size: 12pt, weight: "bold")[#upper(s.name)]
          linebreak()
          text(size: 12pt, weight: "bold")[NIM #s.id]
        }
      ] else [
        #if students.len() > 0 [
          #label-students\
          #if students.len() == 1 {
            let s = students.first()
            [#text(weight: "bold", style: "italic")[#underline(s.name)]\ #s.id]
          } else {
            align(center)[
              #table(
                columns: (auto, auto),
                stroke: none,
                align: (left, right),
                inset: 4pt,
                ..students.map(s => (s.name, s.id)).flatten(),
              )
            ]
          }
        ]
      ]

      #v(1fr)

      #text(weight: "bold")[
        #if university != "" [#upper(university)\ ]
        #if faculty != "" [#label-faculty #upper(faculty)\ ]
        #if department != "" [#label-dept #upper(department)\ ]
        #if program != "" [#label-program #upper(program)\ ]
        #if year != "" [#year]
      ]
    ]
  ]

  body
}
