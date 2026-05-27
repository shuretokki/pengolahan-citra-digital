#let layout(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  number-align: center,
  body,
) = {
  set page(
    paper: paper,
    margin: margin,
    number-align: number-align,
  )

  body
}
