#let title-page(
  title: "",
  course: "",
  lecturer: "",
  nidn: "",
  students: (),
  program: "",
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
  body
) = {
  page(numbering: none)[
    #align(center)[
      #v(cover-top)

      #text(size: cover-title-size, weight: "bold")[#upper(title)]

      #v(1fr)

      #if logo-image != none { logo-image }

      #v(1fr)

      #if course != "" [
        #label-course\
        #text(weight: "bold")[#course]
        #v(cover-gap-course-lecturer)
      ]

      #if lecturer != "" [
        #label-lecturer\
        #text(weight: "bold", style: "italic", underline(lecturer))\
        #if nidn != "" [#nidn]
        #v(cover-gap-lecturer-students)
      ]

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
              ..students.map(s => (s.name, s.id)).flatten()
            )
          ]
        }
      ]

      #v(1fr)

      #text(weight: "bold")[
        #if program != "" [#label-program #upper(program)\ ]
        #if faculty != "" [#label-faculty #upper(faculty)\ ]
        #if university != "" [#upper(university)\ ]
        #if year != "" [#year]
      ]
    ]
  ]

  body
}
