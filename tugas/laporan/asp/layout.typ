#let layout(
  paper: "a4",
  margin-top: 2.5cm,
  margin-bottom: 2.5cm,
  margin-left: 2.5cm,
  margin-right: 2.5cm,
  number-align: center,
  body
) = {
  set page(
    paper: paper,
    margin: (top: margin-top, bottom: margin-bottom, left: margin-left, right: margin-right),
    number-align: number-align,
  )

  body
}
