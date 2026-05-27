#import "../laporan/asp.typ": asp, subfig

#import "@preview/algorithmic:1.0.7"
#import algorithmic: algorithm-figure, style-algorithm
#import "@preview/typixel:0.1.1": *
#show: style-algorithm

#let pixel-with-number(n, txt-color: black) = (width: 0pt, height: 0pt, fill: black) => {
  set text(font: "SF Pro Text")
  box(width: width, height: height, fill: fill, stroke: 0.4pt + gray, {
    align(center + horizon, text(size: width * 0.6, n, fill: txt-color, weight: "bold"))
  })
}

#show: asp.with(
  lang: "id",
  type: emph("LAPORAN TUGAS"),
  cover: (
    type-pos: "top",
  ),
  title: "MORFOLOGI CITRA",
  course: "Pengolahan Citra Digital",
  lecturer: (name: "Dr. Ir. Ricky Eka Putra, S.Kom., M.Kom.", id: "0716018704"),
  students: (
    (name: "Tri Rianto Utomo", id: "24051204104"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",
  outlines-attr: (
    depth: 3,
    figures: false,
    tables: false,
    codes: false,
  ),
)

#pagebreak()
#h(0pt)

= RESUME

== Cara Kerja Morfologi Citra

Morfologi citra bekerja pada citra biner. Alur pengolahannya sebagai berikut:
+ Konversi citra ke _grayscale_
+ Lakukan binerisasi melalui _thresholding_
+ Terapkan operasi morfologi

Kegunaan utama morfologi citra:
- Menghilangkan _noise_
- Mengisi lubang pada objek
- Mengisolasi objek yang saling tumpang tindih

== _Structuring Element_ (SE)

SE merupakan matriks biner yang dirancang sesuai kebutuhan. Elemen SE bernilai 0 atau 1; elemen kosong berarti bebas. Bentuk SE yang umum digunakan:
- *Box* ($3 times 3$ penuh)
- *Disc* (_cross_)
- *Disc besar* ($7 times 7$ lingkaran)

Ukuran SE dapat disesuaikan sesuai kebutuhan aplikasi.

== Hit dan Fit

Dua operasi dasar pada morfologi citra:
- *Hit*: keluaran = 1 apabila _setidaknya satu_ elemen "1" pada SE cocok dengan piksel _foreground_ pada citra masukan.
- *Fit*: keluaran = 1 hanya apabila _seluruh_ elemen "1" pada SE cocok dengan piksel _foreground_ pada citra masukan.

Hit menjadi dasar operasi *dilasi*, sedangkan Fit menjadi dasar operasi *erosi*.

== Dilasi

Dilasi menggunakan operasi Hit. Rumus:
$ g(x, y) = f(x, y) plus.o "SE" $

Efek dilasi pada citra biner:
- Objek _foreground_ (1) membesar
- Lubang pada objek terisi atau hilang
- Sudut tajam dihaluskan
- Objek yang berdekatan dapat bergabung

== Erosi

Erosi menggunakan operasi Fit. Rumus:
$ g(x, y) = f(x, y) minus.o "SE" $

Efek erosi pada citra biner:
- Objek _foreground_ (1) mengecil
- _Noise_ berupa objek kecil menghilang
- Objek yang saling menempel dapat terpisah

Contoh aplikasi erosi: memisahkan koin yang saling tumpang tindih melalui _thresholding_ dan erosi.

== Operasi Gabungan (_Compound Operations_)

=== Ekstraksi _Outline_

_Outline_ objek diperoleh melalui substraksi citra asli dengan citra hasil dilasi:
+ Lakukan dilasi
+ Substraksi citra asli dari citra hasil dilasi
+ Diperoleh _outline_

=== _Opening_

_Opening_ menghilangkan objek kecil namun tetap mempertahankan ukuran objek besar.

$ f(x, y) circle.stroked.tiny "SE" = (f(x, y) minus.o "SE") plus.o "SE" $

- _Opening_ = Erosi diikuti Dilasi (menggunakan SE yang sama)
- Hampir sama dengan erosi, namun tidak terlalu _destructive_
- Bersifat *idempoten*: pengulangan _opening_ tidak memberikan efek tambahan

=== _Closing_

_Closing_ mengisi lubang pada objek namun tetap menjaga ukuran aslinya.

$ f(x, y) bullet "SE" = (f(x, y) plus.o "SE") minus.o "SE" $

- _Closing_ = Dilasi diikuti Erosi (menggunakan SE yang sama)
- Hampir sama dengan dilasi, namun tidak terlalu _destructive_
- Bersifat *idempoten*: pengulangan _closing_ tidak memberikan efek tambahan

=== Kombinasi _Closing_ dan _Opening_

Kombinasi kedua operasi tersebut menghasilkan citra yang bersih dari _noise_ sekaligus lubang:
+ *_Closing_* terlebih dahulu: menutup _noise_ di dalam objek
+ *_Opening_* kemudian: menghilangkan _noise_ kecil di luar objek

== Ringkasan

#table(
  columns: (auto, 1fr, 1fr),
  align: (center, left, left),
  table.header([*Operasi*], [*Formula*], [*Efek*]),
  [Dilasi], [$f plus.o "SE"$], [Objek membesar dan lubang terisi],
  [Erosi], [$f minus.o "SE"$], [Objek mengecil dan _noise_ hilang],
  [_Opening_], [$(f minus.o "SE") plus.o "SE"$], [Membuang _noise_ tanpa menyusutkan objek],
  [_Closing_], [$(f plus.o "SE") minus.o "SE"$], [Menutup lubang tanpa memperbesar objek],
)


= LATIHAN

== Soal

#text(font: "Libertinus Serif", figure(
  block(stroke: 0.2pt, inset: 1em, radius: 0pt)[
    #grid(
      columns: 2,
      gutter: 2em,
      grid(
        align: (left + horizon),
        columns: 1,
        gutter: 0.8em,
        smallcaps[Diberikan Citra Biner],
        smallcaps[- Dilation],
        smallcaps[- Erosion],
        smallcaps[- Closing],
        smallcaps[- Opening],

        grid(
          columns: 1,
          gutter: 1em,
          align: center,

          smallcaps[Structuring Element],
          pixel-map(
            "
          XXX
          XXX
          XXX
          ",
            palette: ("X": black),
            shape: ("X": pixel-with-number("1", txt-color: white)),
            pixel-size: 13pt,
            gap: 1pt,
          ),
        ),
      ),

      pixel-map(
        "
      ..........
      ..........
      ..XX..X...
      ...XXXXX..
      ..XXXXX...
      ..XXXX....
      ..XXXXX...
      ...XXXX...
      ..........
      ..........
      ",
        palette: ("X": black, ".": white),
        shape: (
          "X": pixel-with-number("1", txt-color: white),
          ".": pixel-with-number("0", txt-color: black),
        ),
        pixel-size: 15pt,
        gap: 0pt,
      ),
    )
  ],
))

== Jawab


#text(font: "Libertinus Serif")[
  #figure(grid(
    columns: 2,
    gutter: 1em,
    row-gutter: 0.8em,

    grid(
      columns: 1,
      gutter: 0.4em,
      pixel-map(
        "
          ..........
          .XXXXXXX..
          .XXXXXXXX.
          .XXXXXXXX.
          .XXXXXXXX.
          .XXXXXXX..
          .XXXXXXX..
          .XXXXXXX..
          ..XXXXXX..
          ..........
          ",
        palette: ("X": black, ".": white),
        shape: ("X": pixel-with-number("1", txt-color: white), ".": pixel-with-number("0", txt-color: black)),
        pixel-size: 14pt,
        gap: 0pt,
      ),
      align(center + horizon, smallcaps[dilation]),
    ),

    grid(
      columns: 1,
      gutter: 0.4em,
      pixel-map(
        "
          ..........
          ..........
          ..........
          ..........
          ....X.....
          ...XX.....
          ....X.....
          ..........
          ..........
          ..........
          ",
        palette: ("X": black, ".": white),
        shape: ("X": pixel-with-number("1", txt-color: white), ".": pixel-with-number("0", txt-color: black)),
        pixel-size: 14pt,
        gap: 0pt,
      ),
      align(center + horizon, smallcaps[erosion]),
    ),

    grid(
      columns: 1,
      gutter: 0.4em,
      pixel-map(
        "
          ..........
          ..........
          ..........
          ...XXX....
          ..XXXX....
          ..XXXX....
          ..XXXX....
          ...XXX....
          ..........
          ..........
          ",
        palette: ("X": black, ".": white),
        shape: ("X": pixel-with-number("1", txt-color: white), ".": pixel-with-number("0", txt-color: black)),
        pixel-size: 14pt,
        gap: 0pt,
      ),
      align(center + horizon, smallcaps[opening]),
    ),

    grid(
      columns: 1,
      gutter: 0.4em,
      pixel-map(
        "
          ..........
          ..........
          ..XXXXX...
          ..XXXXXX..
          ..XXXXX...
          ..XXXXX...
          ..XXXXX...
          ...XXXX...
          ..........
          ..........
          ",
        palette: ("X": black, ".": white),
        shape: ("X": pixel-with-number("1", txt-color: white), ".": pixel-with-number("0", txt-color: black)),
        pixel-size: 14pt,
        gap: 0pt,
      ),
      align(center + horizon, smallcaps[closing]),
    ),
  ))
]
