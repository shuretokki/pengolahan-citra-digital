#import "../laporan/asp.typ": asp, subfig

#let SL_MARK = "sublabel-marker"
#show figure.where(kind: image): it => {
  show figure.caption: c => {
    set align(left)
    set text(size: 10pt)
    set par(leading: 1.1em)
    let body = c.body
    let sl-data = none

    if body.has("children") {
      for child in body.children {
        if child.func() == metadata and type(child.value) == dictionary and child.value.at("kind", default: none) == SL_MARK {
          sl-data = child.value
          break
        }
      }
    } else if body.func() == metadata and type(body.value) == dictionary and body.value.at("kind", default: none) == SL_MARK {
      sl-data = body.value
    }

    if sl-data != none {
      let c_cols = if sl-data.cols == none { sl-data.labels.length } else { sl-data.cols }
      let sl-grid = grid(
        columns: (auto,) * c_cols,
        gutter: 0.2em,
        ..sl-data.labels.map(it => box(
          fill: luma(240),
          radius: 0pt,
          inset: 2pt,
          stroke: 0pt,
          text(size: 8pt, font: "Times New Roman", it)
        ))
      )

      grid(
        columns: (auto, 1fr),
        gutter: 1em,
        align: top,
        sl-grid,
        [ *#c.supplement #c.counter.display(c.numbering):* #body ]
      )
    } else {
      [ *#c.supplement #c.counter.display(c.numbering):* #body ]
    }
  }
  it
}

#let sublabel(cols: none, ..args) = metadata((
  kind: SL_MARK,
  cols: cols,
  labels: args.pos()
))


#show: asp.with(
  lang: "id",
  title: "Laporan Tugas 4:\nHistogram Processing dan Spatial Filtering",
  course: "Pengolahan Citra Digital",
  lecturer: "Dr. Ir. Ricky Eka Putra, S.Kom., M.Kom.",
  nidn: "0707039601",
  students: (
    (name: "Tri Rianto Utomo", id: "24051204104"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",
  frontmatter: []
)

#pagebreak()
#h(0pt)

= RESUME

== Histogram

Histogram didefinisikan sebagai grafik yang menunjukkan distribusi frekuensi intensitas pixel pada suatu gambar, di mana jika kita memisalkan $r_k$ sebagai intensitas gambar $L$-level $f(x, y)$ untuk rentang $k = 0, 1, 2, dots, L - 1$, maka representasi distribusi frekuensi tersebut dapat dinyatakan dalam dua bentuk utama, yaitu:

/ _Unnormalized Histogram_: yaitu fungsi $h(r_k) = n_k$, di mana $n_k$ merepresentasikan jumlah pixel pada gambar $f$ yang memiliki tingkat intensitas $r_k$, dengan pembagian tiap skala intensitasnya disebut sebagai _histogram bins_, yakni:
  $ h(r_k) = n_k &quad ; n_k "adalah jumlah pixel dengan intensitas " r_k $

/ _Normalized Histogram_: yaitu fungsi $p(r_k) = n_k/(M N)$, di mana $M$ dan $N$ merupakan dimensi baris dan kolom dari gambar tersebut, sehingga nilai $p(r_k)$ berfungsi sebagai estimasi probabilitas dari kemunculan tingkat intensitas dalam suatu gambar, yakni:
  $ p(r_k) = n_k/(M N) &quad ; M, N "adalah dimensi gambar" $


#figure(
  grid(
    columns: 2,
    gutter: 0em,
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0006.jpg"), []),
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0016.jpg"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b")
    (a) Slide 6, (b) Slide 16
  ]
)

== Histogram Equalization

_Histogram Equalization_ merupakan sebuah teknik pemrosesan yang bertujuan untuk secara otomatis meningkatkan kontras gambar melalui pemerataan distribusi histogram, di mana proses ini menggunakan fungsi transformasi $T(r_k)$ yang didasarkan pada jumlahan kumulatif dari probabilitas intensitas input untuk menghasilkan tingkat output $s_k$ yang tersebar lebih merata di seluruh rentang grayscale, yaitu:
$ s_k = T(r_k) = (L - 1) sum_(j=0)^k p_r(r_j) &quad ; k = 0, 1, 2, dots, L - 1 $
sehingga setiap pixel pada gambar _output_ didapatkan melalui hasil _mapping_ nilai $r_k$ ke level $s_k$ yang baru, yang secara efektif meregangkan histogram asli untuk mencakup jangkauan intensitas yang lebih luas.

#figure(
  grid(
    columns: 2,
    gutter: 0em,
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0014.jpg"), []),
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0024.jpg"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b")
    (a) Slide 14, (b) Slide 24
  ]
)

== Spatial Filtering

_Spatial filtering_ bekerja dengan menggeser _kernel_ berukuran $m times n$ di atas gambar, di mana _kernel_ adalah sebuah _array_ yang ukurannya mendefinisikan _neighborhood_, sementara koefisien-koefisiennya menentukan sifat dari filter tersebut, serta koordinat $m$ dan $n$ yang biasanya berupa bilangan ganjil ($2a + 1$ dan $2b + 1$).

/ _Linear spatial filter_: bekerja dengan cara mengalikan koefisien _kernel_ dengan nilai pixel tetangga lalu menjumlahkannya, yang dinyatakan melalui korelasi spasial:
  $ (w star f)(x, y) = limits(sum)_(s=-a)^a limits(sum)_(t=-b)^b w(s, t)f(x + s, y + t) $
  sedangkan pada konvolusi, mekanismenya serupa dengan korelasi, namun dilakukan dengan memutar _kernel_ sebesar $180^degree$ terlebih dahulu.
  $ (w ast f)(x, y) = limits(sum)_(s=-a)^a limits(sum)_(t=-b)^b w(s, t)f(x - s, y - t) $

/ _Nonlinear spatial filter_: memberikan output berdasarkan _ranking_ nilai pixel dalam _neighborhood_, yang sering kali dikategorikan sebagai _order-statistic filter_.

#figure(
  image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0036.jpg", width: 80%),
  caption: [Slide 36],
)

=== Smoothing

_Smoothing spatial filters_ (filter _lowpass_) mengurangi _noise_ dengan menghitung rata-rata pada _neighborhood_ $m times n$:
$ g(x,y) = (limits(sum)_(s=-a)^a limits(sum)_(t=-b)^b w(s,t) f(x+s, y+t)) / (limits(sum)_(s=-a)^a limits(sum)_(t=-b)^b w(s,t)) $

Terdapat beberapa kategori filter _smoothing_:
/ _Box filter_: filter _lowpass_ linier paling sederhana yang menggunakan bobot seragam $w(s,t) = 1$, sehingga setiap pixel dalam _neighborhood_ berkontribusi rata terhadap hasil akhir melalui faktor normalisasi $1/m n$.
/ _Gaussian filter_: menggunakan koefisien yang ditentukan oleh fungsi eksponensial:
  $ G(s,t) = K e^(-(s^2+t^2) / (2 sigma^2)) $
  Kernel ini bersifat _circularly symmetric_ sekaligus _separable_, yang memungkinkan optimasi efisiensi komputasi dari $M^2$ menjadi $2M$.
/ _Order-statistic filter_: kategori filter non-linier di mana output ditentukan oleh _ranking_ intensitas pixel dalam _neighborhood_.

#figure(
  grid(
    columns: 2,
    gutter: 0.2em,
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0040.jpg"), []),
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0041.jpg"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b")
    (a) Slide 40, (b) Slide 41
  ]
)

=== Sharpening
_Sharpening spatial filtering_ atau _highpass filtering_ berfungsi untuk *edge enhancement* berdasarkan prinsip diferensiasi spasial. Ada dua jenis turunan yang umum digunakan:
+ Turunan pertama (ordo satu):
  $ (partial f)/(partial x) = f(x+1, y) - f(x, y) $
+ Turunan kedua (ordo dua):
  $ (partial^2 f)/(partial x^2) = f(x+1, y) + f(x-1, y) - 2f(x, y) $
Dalam praktiknya, turunan kedua lebih sensitif dalam menangkap detail halus yang mungkin terlewat oleh turunan pertama. Oleh karena itu, kita menggunakan operator _Laplacian_ sebagai filter isotropik:
$ nabla^2 f(x, y) = f(x+1, y) + f(x-1, y) + f(x, y+1) + f(x, y-1) - 4f(x, y) $
Hasil penajaman akhir diperoleh dengan menambahkan kembali output _Laplacian_ ke gambar asli melalui konstanta skala $c$:
$ g(x, y) = f(x, y) + c [nabla^2 f(x, y)] $
Selain itu, untuk pendekatan turunan ordo satu, kita dapat memanfaatkan magnitudo _gradient_ $nabla f$ dengan pendekatan $M(x, y) approx |g_x| + |g_y|$. Komponen $g_x$ dan $g_y$ umumnya diperoleh melalui _Sobel operators_ untuk mendeteksi transisi pada arah horizontal dan vertikal.

#figure(
  grid(
    columns: 2,
    gutter: 0.2em,
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0040.jpg"), []),
    subfig(image("Lecture4/Slide-04-Histogram-dan-Spatial-Filtering_page-0042.jpg"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b")
    (a) Slide 40, (b) Slide 42
  ]
)

= LATIHAN

== Soal

#figure(
  block(stroke: 0.2pt, inset: 1em, radius: 0pt)[
    #grid(
      columns: 2,
      gutter: 2em,
      align(left + horizon)[+ Bagaimana hasil yang diperoleh jika pada citra tersebut dilewatkan filter lowpass],
      table(
        columns: (auto, auto, auto, auto),
        inset: 4pt,
        stroke: 0.2pt,
        align: center,
        [29], [10], [12], [13],
        [34], [12], [13], [13],
        [31], [10], [11], [12],
        [30], [11], [14], [14],
        [31], [12], [12], [11],
      ),
    )
  ]
)
== Jawaban

Pada latihan ini, saya mengimplementasikan dua teknik _spatial filtering_ untuk kategori _lowpass_, yakni _box filter_ dan _Gaussian filter_.

/ _Box Filter_: \
    Di sini, saya menggunakan size kernel $k=3$ dan $k=5$, serta mencoba berbagai teknik _padding_ seperti _Zero Fill_, _Replication_, dan _Mirroring_. Untuk _Mirroring_, saya menerapkan metode _Symmetric Mirroring_ atau _Reflect 101_.

#pagebreak()

+ $k=3$: \
  #let matrix(cols, ..args) = table(
    columns: (16pt,) * cols,
    rows: 16pt,
    inset: 0pt,
    stroke: 0.2pt,
    align: center + horizon,
    ..args
  )

  #let p(it) = table.cell(fill: luma(240), it)
  #let img(it) = table.cell(fill: white, it)
  #let org(it) = table.cell(fill: yellow.lighten(60%), it)
  #let out(it) = table.cell(fill: yellow.lighten(80%), it)

  #align(center)[
    #stack(dir: ltr, spacing: 1em,
      box(baseline: 20%, fill: white, stroke: 0.2pt, width: 10pt, height: 10pt), [ Image ],
      box(baseline: 20%, fill: luma(240), stroke: 0.2pt, width: 10pt, height: 10pt), [ Padding ],
      box(baseline: 20%, fill: yellow.lighten(60%), stroke: 0.2pt, width: 10pt, height: 10pt), [ $f(0,0)$ ],
      box(baseline: 20%, fill: yellow.lighten(80%), stroke: 0.2pt, width: 10pt, height: 10pt), [ $g(x,y)$ ]
    )
  ]

  #figure(
    table(
      columns: (1fr, 1fr, 1fr),
      inset: 8pt,
      stroke: 0pt,
      align: center + horizon,
      [*Zero Fill*], [*Replication*], [*Mirror*],

      [
        #matrix(6,
          p[0],p[0],p[0],p[0],p[0],p[0],
          p[0],org[29],img[10],img[12],img[13],p[0],
          p[0],img[34],img[12],img[13],img[13],p[0],
          p[0],img[31],img[10],img[11],img[12],p[0],
          p[0],img[30],img[11],img[14],img[14],p[0],
          p[0],img[31],img[12],img[12],img[11],p[0],
          p[0],p[0],p[0],p[0],p[0],p[0]
        )
        #v(0em)
        #text(size: 8pt)[*(a)*]
      ],
      [
        #matrix(6,
          p[29],p[29],p[10],p[12],p[13],p[13],
          p[29],org[29],img[10],img[12],img[13],p[13],
          p[34],img[34],img[12],img[13],img[13],p[13],
          p[31],img[31],img[10],img[11],img[12],p[12],
          p[30],img[30],img[11],img[14],img[14],p[14],
          p[31],img[31],img[12],img[12],img[11],p[11],
          p[31],p[31],p[12],p[12],p[11],p[11]
        )
        #v(0em)
        #text(size: 8pt)[*(b)*]
      ],
      [
        #matrix(6,
          p[12],p[34],p[12],p[13],p[13],p[13],
          p[10],org[29],img[10],img[12],img[13],p[12],
          p[12],img[34],img[12],img[13],img[13],p[13],
          p[10],img[31],img[10],img[11],img[12],p[11],
          p[11],img[30],img[11],img[14],img[14],p[14],
          p[12],img[31],img[12],img[12],img[11],p[12],
          p[11],p[30],p[11],p[14],p[14],p[14]
        )
        #v(0em)
        #text(size: 8pt)[*(c)*]
      ],

      [
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          align: horizon,
          matrix(3, p[0],p[0],p[0], p[0],org[29],img[10], p[0],img[34],img[12]),
          align(left)[
            #set text(9pt)
            $g(x,y) &= 1/9 sum_(i=1)^9 f_i \
             g(0,0) &= 1/9 (85) \
                   &bold(approx 9.44)$
          ]
        )
        #v(0em)
        #text(size: 8pt)[*(d)*]
      ],
      [
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          align: horizon,
          matrix(3, p[29],p[29],p[10], p[29],org[29],img[10], p[34],img[34],img[12]),
          align(left)[
            #set text(9pt)
            $g(x,y) &= 1/9 sum_(i=1)^9 f_i \
             g(0,0) &= 1/9 (216) \
                   &bold(= 24)$
          ]
        )
        #v(0em)
        #text(size: 8pt)[*(e)*]
      ],
      [
        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          align: horizon,
          matrix(3, p[12],p[34],p[12], p[10],org[29],img[10], p[12],img[34],img[12]),
          align(left)[
            #set text(9pt)
            $g(x,y) &= 1/9 sum_(i=1)^9 f_i \
             g(0,0) &= 1/9 (165) \
                   &bold(approx 18.33)$
          ],
        )
        #v(0em)
        #text(size: 8pt)[*(f)*]
      ],

      [
        #matrix(4,
          out[9], out[12], out[8], out[6],
          out[14], out[18], out[12], out[8],
          out[14], out[18], out[12], out[9],
          out[14], out[18], out[12], out[8],
          out[9], out[12], out[8], out[6]
        )
        #v(0em)
        #text(size: 8pt)[*(g)*]
      ],
      [
        #matrix(4,
          out[24], out[18], out[12], out[13],
          out[24], out[18], out[12], out[12],
          out[25], out[18], out[12], out[13],
          out[24], out[18], out[12], out[12],
          out[24], out[18], out[12], out[12]
        )
        #v(0em)
        #text(size: 8pt)[*(h)*]
      ],
      [
        #matrix(4,
          out[18], out[19], out[12], out[13],
          out[18], out[18], out[12], out[12],
          out[18], out[18], out[12], out[13],
          out[18], out[18], out[12], out[12],
          out[18], out[18], out[13], out[13]
        )
        #v(0em)
        #text(size: 8pt)[*(i)*]
      ],
    ),
    kind: image,
    caption: [Langkah perhitungan _box filter_ dengan $k = 3$. (a)-(c) input (_padded_). (d)-(f) proses hitung $g(0,0)$. (g)-(i) _output_.]
  )

+ $k=5$: \
  #align(center)[
    #stack(dir: ltr, spacing: 1em,
      box(baseline: 20%, fill: yellow.lighten(80%), stroke: 0.2pt, width: 10pt, height: 10pt), [ $g(x,y)$ ]
    )
  ]

  #figure(
    grid(
      columns: (1fr, 1fr, 1fr),
      gutter: 1em,
      [
        #matrix(4,
          out[6], out[8], out[8], out[4],
          out[9], out[11], out[11], out[6],
          out[11], out[13], out[13], out[7],
          out[9], out[11], out[11], out[6],
          out[6], out[8], out[8], out[4]
        )
        #text(8pt)[(a)]
      ],
      [
        #matrix(4,
          out[23], out[19], out[16], out[12],
          out[23], out[19], out[16], out[12],
          out[23], out[20], out[16], out[12],
          out[24], out[20], out[16], out[12],
          out[23], out[19], out[16], out[12]
        )
        #text(8pt)[(b)]
      ],
      [
        #matrix(4,
          out[15], out[16], out[16], out[12],
          out[16], out[16], out[16], out[12],
          out[16], out[16], out[16], out[12],
          out[16], out[16], out[16], out[12],
          out[15], out[15], out[16], out[12]
        )
        #text(8pt)[(c)]
      ]
    ),
    kind: image,
    caption: [Hasil _box filter_ dengan $k = 5$: (a) _Zero Fill_, (b) _Replication_, (c) _Mirroring_.]
  ) <gambar-2.2>

#pagebreak()

/ _Gaussian Filter_:
  + $sigma approx 0.8$ ($3 times 3$): \

    #align(center)[
      #stack(dir: ltr, spacing: 1em,
        box(baseline: 20%, fill: white, stroke: 0.2pt, width: 10pt, height: 10pt), [ Image ],
        box(baseline: 20%, fill: luma(240), stroke: 0.2pt, width: 10pt, height: 10pt), [ Padding ],
        box(baseline: 20%, fill: yellow.lighten(60%), stroke: 0.2pt, width: 10pt, height: 10pt), [ $f(0,0)$ ],
        box(baseline: 20%, fill: green.lighten(80%), stroke: 0.2pt, width: 10pt, height: 10pt), [ Kernel ],
        box(baseline: 20%, fill: yellow.lighten(80%), stroke: 0.2pt, width: 10pt, height: 10pt), [ $g(x,y)$ ]
      )
    ]

    #figure(
      grid(
        columns: (auto, auto, auto, auto),
        rows: (auto, auto),
        column-gutter: 1.2em,
        row-gutter: 0.6em,
        align: center,

        align(horizon)[
          #matrix(6,
            p[12],p[34],p[12],p[13],p[13],p[13],
            p[10],org[29],img[10],img[12],img[13],p[12],
            p[12],img[34],img[12],img[13],img[13],p[13],
            p[10],img[31],img[10],img[11],img[12],p[11],
            p[11],img[30],img[11],img[14],img[14],p[14],
            p[12],img[31],img[12],img[12],img[11],p[12],
            p[11],p[30],p[11],p[14],p[14],p[14]
          )
        ],
        align(horizon)[
          #table(
            columns: (14pt,) * 3,
            rows: 14pt,
            inset: 0pt,
            stroke: 0.2pt,
            fill: (_, row) => green.lighten(80%),
            align: center + horizon,
            [1],[2],[1],[2],[4],[2],[1],[2],[1]
          )
        ],
        align(horizon)[
          #set text(8pt)
          #set math.equation(numbering: none)
          $ g(x,y) &= 1/16 sum w_(i,j) f_(i,j) \
          g(0,0) &= 1/16 [ (1 dot 12 + 2 dot 34 + 1 dot 12) \
                 &quad + (2 dot 10 + 4 dot 29 + 2 dot 10) \
                 &quad + (1 dot 12 + 2 dot 34 + 1 dot 12) ] \
                 &= 1/16 (340) approx bold(21) $
        ],
        align(horizon)[
          #matrix(4,
            out[21], out[16], out[12], out[13],
            out[22], out[17], out[12], out[12],
            out[21], out[16], out[12], out[12],
            out[21], out[16], out[12], out[13],
            out[21], out[17], out[12], out[13]
          )
        ],

        text(8pt)[*(a)*],
        text(8pt)[*(b)*],
        text(8pt)[*(c)*],
        text(8pt)[*(d)*]
      ),
      kind: image,
      caption: [Tahapan _Gaussian filter_ berukuran $3 times 3$: (a) _input (padded)_. (b) _kernel_. (c) proses hitung $g(0, 0)$. (d) _output_.]
    )

  + $6sigma$: \

    #align(center)[
      #stack(dir: ltr, spacing: 1em,
        box(baseline: 20%, fill: yellow.lighten(80%), stroke: 0.2pt, width: 10pt, height: 10pt), [ $g(x,y)$ ]
      )
    ]

    #figure(
      grid(
        columns: (1fr, 1fr),
        rows: (auto, auto),
        gutter: 1em,
        // Row 1: Content
        [
          #matrix(4, out[16], out[13], out[12], out[12], out[16], out[13], out[12], out[12], out[16], out[13], out[12], out[12], out[16], out[13], out[12], out[12], out[16], out[13], out[12], out[12])
          #v(0.4em)
          #text(8pt)[*(a)*]
          #v(0.4em)
          #text(8pt)[*(a)*]
        ],
        [
          #matrix(4, out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19], out[19])
          #v(0.4em)
          #text(8pt)[*(b)*]
          #v(0.4em)
          #text(8pt)[*(b)*]
        ],
      ),
      kind: image,
      caption: [Hasil _Gaussian filter_ dengan $6 sigma$: (a) $sigma = 3$. (b) $sigma = 9$.]
    )

#pagebreak()

= DEMO PROGRAM

Kode program lengkap untuk tugas ini dapat diakses melalui .

== Histogram Equalization

#figure(
  ```cpp
  std::vector<int> h[3];
  for (auto i = 0; i < 3; ++i)
    h[i].assign(256, 0);

  for (auto y = 0; y < src.rows; ++y) {
    for (auto x = 0; x < src.cols; ++x) {
      Vec3b p = src.at<Vec3b>(y, x);
      for (auto i = 0; i < 3; ++i)
        h[i][p[i]]++;
    }
  }
  ```,
  caption: [Perhitungan histogram.],
  kind: raw
)

#figure(
  ```cpp
  double sum[3] = {0, 0, 0};
  for (auto i = 0; i < 256; ++i) {
    for (auto j = 0; j < 3; ++j) {
      sum[j] += static_cast<double>(h[j][i]) / totalPixels;
      lut[j][i] = saturate_cast<uchar>(255 * sum[j]);
    }
  }
  ```,
  caption: [Pembentukan LUT melalui normalisasi CDF.],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og_1.png", ), []),
    subfig(image("output/histogram_og_1.png"), []),
    subfig(image("output/eq_1.png"), []),
    subfig(image("output/histogram_eq_1.png"), [])
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Hasil _histogram equalization_: (a) gambar asli berukuran $600 times 600$ pixel, (b) histogram asli, (c) gambar hasil ekualisasi, (d) histogram hasil ekualisasi.
  ]
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og_2.png"), []),
    subfig(image("output/histogram_og_2.png"), []),
    subfig(image("output/eq_2.png"), []),
    subfig(image("output/histogram_eq_2.png"), [])
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Hasil _histogram equalization_: (a) gambar asli berukuran $600 times 600$ pixel, (b) histogram asli, (c) gambar hasil ekualisasi, (d) histogram hasil ekualisasi.
  ]
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og_3.png"), []),
    subfig(image("output/eq_3.png"), []),
    subfig(image("output/histogram_og_3.png"), []),
    subfig(image("output/histogram_eq_3.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Hasil _histogram equalization_: (a) gambar asli berukuran $1024 times 1856$ pixel, (b) gambar hasil ekualisasi, (c) histogram asli, (d) histogram hasil ekualisasi.
  ]
)

== Spatial Filtering


=== Box Filter

#figure(
  ```cpp
  int r = k / 2;
  for (auto y = 0; y < src.rows; ++y) {
    for (auto x = 0; x < src.cols; ++x) {
      Vec3f sum = {0, 0, 0};
      for (auto ky = -r; ky <= r; ++ky) {
        for (auto kx = -r; kx <= r; ++kx) {
          // logika padding (kode 3.4, 3.5, atau 3.6)
        }
      }
      for (int c = 0; c < 3; ++c)
        box.at<Vec3b>(y, x)[c] = saturate_cast<uchar>(sum[c] / (k * k));
    }
  }
  ```,
  caption: [Struktur implementasi _box filter_ untuk _kernel_ $k$.],
  kind: raw
)

#pagebreak()

#figure(
  ```cpp
  auto ny = y + ky; auto nx = x + kx;
  if (ny >= 0 && ny < src.rows && nx >= 0 && nx < src.cols) {
    Vec3b p = src.at<Vec3b>(ny, nx);
    for (auto i = 0; i < 3; ++i)
      sum[i] += p[i];
  }
  ```,
  caption: [Implementasi _zero padding_],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og.png"), []),
    subfig(image("output/box_zero_k7.png"), []),
    subfig(image("output/box_zero_k15.png"), []),
    subfig(image("output/box_zero_k31.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Perbandingan hasil _box filter_ dengan _zero fill_: (a) gambar asli berukuran $600 times 600$ pixel, (b) $k=7$, (c) $k=15$, (d) $k=31$.
  ]
)

#figure(
  ```cpp
  auto ny = std::clamp(y + ky, 0, src.rows - 1);
  auto nx = std::clamp(x + kx, 0, src.cols - 1);

  Vec3b p = src.at<Vec3b>(ny, nx);
  for (auto i = 0; i < 3; ++i)
    sum[i] += p[i];
  ```,
  caption: [Implementasi _replication padding_],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og.png"), []),
    subfig(image("output/box_rep_k7.png"), []),
    subfig(image("output/box_rep_k15.png"), []),
    subfig(image("output/box_rep_k31.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Perbandingan hasil _box filter_ dengan _replication padding_: (a) gambar asli berukuran $600 times 600$ pixel, (b) $k=7$, (c) $k=15$, (d) $k=31$.
  ]
)

#figure(
  ```cpp
  auto reflect101 = [](int p, int max) {
    if (p < 0) return -p;
    if (p >= max) return 2 * max - p - 2;
    return p;
  };

  Vec3b p = src.at<Vec3b>(reflect101(y + ky, src.rows),
                          reflect101(x + kx, src.cols));
  for (auto i = 0; i < 3; ++i)
    sum[i] += p[i];
  ```,
  caption: [Implementasi _reflect 101_.],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og.png"), []),
    subfig(image("output/box_mirror_k7.png"), []),
    subfig(image("output/box_mirror_k15.png"), []),
    subfig(image("output/box_mirror_k31.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Perbandingan hasil _box filter_ dengan _mirror padding_: (a) gambar asli berukuran $600 times 600$ pixel, (b) $k=7$, (c) $k=15$, (d) $k=31$.
  ]
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og.png"), []),
    subfig(image("output/box_zero_k31.png"), []),
    subfig(image("output/box_rep_k31.png"), []),
    subfig(image("output/box_mirror_k31.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Perbandingan pengaruh teknik _padding_ pada _kernel_ besar ($k=31$): (a) gambar asli berukuran $600 times 600$ pixel, (b) _zero fill_, (c) _replication_, (d) _mirror padding_.
  ]
)

=== Gaussian Filter

#figure(
  ```cpp
  double val = exp(-(kx * kx + ky * ky) / (2 * sigma * sigma))
               / (2 * M_PI * sigma * sigma);

  for (int i = 0; i < 3; ++i)
    gaussian.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(sum[i]);
  ```,
  caption: [Implementasi pembentukan kernel dan konvolusi Gaussian.],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og.png"), []),
    subfig(image("output/gaussian_s1.png"), []),
    subfig(image("output/gaussian_s2_5.png"), []),
    subfig(image("output/gaussian_s5.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b", "c", "d")
    Perbandingan hasil _Gaussian filter_ pada gambar berukuran $600 times 600$ pixel: (a) gambar asli, (b) $sigma = 1$, (c) $sigma = 2.5$, (d) $sigma = 5$.
  ]
)


=== Box vs Gaussian Filter

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/comp_box_1.png"), []),
    subfig(image("output/comp_gauss_1.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b")
    Perbandingan _Box_ vs _Gaussian Filter_ ($600 times 600$ pixel): (a) _box filter_ menghasilkan _blurring_ yang lebih kaku, (b) _Gaussian filter_ memberikan degradasi warna yang lebih halus.
  ]
)



== Image Sharpening

=== Laplacian Filtering


#figure(
  ```cpp
  int lap4K[3][3] = {{0, 1, 0}, {1, -4, 1}, {0, 1, 0}};
  int lap8K[3][3] = {{1, 1, 1}, {1, -8, 1}, {1, 1, 1}};
  // ... loop ...
  sharp = saturate_cast<uchar>(original - laplace_sum);
  ```,
  caption: [Implementasi filter Laplacian (4N & 8N).],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og_sharpen.png"), []),
    subfig(image("output/sharpen_laplacian.png"), []),
    subfig(image("output/sharpen_laplacian_8.png"), []),
  ),
  caption: [
    #sublabel(cols: 3, "a", "b", "c")
    Perbandingan Laplacian (800 × 800 pixel): (a) asli, (b) 4-neighbor, (c) 8-neighbor.
  ]
)


=== Sobel Gradient

#figure(
  ```cpp
  int hx[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
  int hy[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
  // ... gx += p * hx; gy += p * hy ...
  sobel = saturate_cast<uchar>(abs(gx) + abs(gy));
  ```,
  caption: [Implementasi operator Sobel.],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og_sharpen.png"), []),
    subfig(image("output/sharpen_sobel.png"), []),
  ),
  caption: [
    #sublabel(cols: 2, "a", "b")
    Hasil Sobel Gradient (800 × 800 pixel): (a) asli, (b) edge detection (high contrast).
  ]
)



=== Unsharp Masking & Highboost Filtering

#figure(
  ```cpp
  double mask = original - blurred;
  unsharp = saturate_cast<uchar>(original + 1.0 * mask);
  highboost = saturate_cast<uchar>(original + 4.5 * mask);
  ```,
  caption: [Implementasi unsharp masking dan highboost filtering.],
  kind: raw
)

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("output/og_sharpen.png"), []),
    subfig(image("output/sharpen_unsharp.png"), []),
    subfig(image("output/sharpen_highboost.png"), []),
  ),
  caption: [
    #sublabel(cols: 3, "a", "b", "c")
    Hasil masking (800 × 800 pixel): (a) asli, (b) unsharp (k=1), (c) highboost (k=4.5).
  ]
)

