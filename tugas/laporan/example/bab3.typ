#let img = (
  my: "img-1.png",
  myb: "img-2.jpg",
)

= BAB III \ VISUALISASI DATA DAN DOKUMEN LAYOUT

Menyajikan output _image_ dan skema desain (_architecture layout_) membutuhkan keseimbangan komposisi. Typst menyediakan banyak kontrol otomatis untuk menetapkan lebar _element_, menyelaraskan objek horizontal (grid), hingga split page layaknya laporan _IEEE conference_.

== Single Aspect Ratio Float

Secara _default_, tag `#figure` menampung image tunggal dan caption yang dijangkar ke penomoran dinamis. Opsi paling direkomendasikan adalah menentukan dimensi proporsional berdasar lebar halaman aktif (_percentage width_):

#figure(
  image(img.myb, width: 80%),
  caption: [Parameter (`width: 80%`) mengunci relasi ukuran terhadap _margins_ samping yang dikonfigurasi pada fungsi _template cover_.],
) <fig-persen>

Untuk komponen fisis (seperti desain sirkuit board atau dimensi frame UI) yang memiliki resolusi paten, gunakan absolute threshold:

#figure(
  image(img.my, width: 8cm),
  caption: [Layout constraint absolut. Rendering dokumen tetap statis di ukuran (8cm).],
) <fig-absolut>

== Labeled Comparison

Membandingkan perubahan _state_ atau transformasi berulang sering disajikan menggunakan dua _image output_ yang berdiri berdampingan. Function `grid` mengatur kolom agar gambar selaras sejajar tanpa wrap error:

#figure(
  grid(
    columns: 2,
    gutter: 1em,
    figure(image(img.my, height: 6cm), caption: [(a) Input OG (original)]),
    figure(image(img.myb, height: 6cm), caption: [(b) Thresholding (processed)]),
  ),
  caption: [Sistem komparasi *Labeled Subfigures*. Height parameter dipatok fixed (6cm) agar base dari kedua frame tidak bersilangan miring.],
) <fig-komparasi>

== Complex Visual Grid

Bukan cuma 2 frame _figure_; Typst me-_render_ matriks visual dalam galeri berurutan dengan opsi kolom fleksibel (misal, `columns: 4`). Ini wajib digunakan ketika melakukan visualisasi per bit, seperti pada uji _bit-plane slicing_.

#figure(
  grid(
    columns: 4,
    gutter: 0.5em,
    align: center,
    image(img.my, width: 100%),
    image(img.myb, width: 100%),
    image(img.myb, width: 100%),
    image(img.my, width: 100%),
  ),
  caption: [Visualisasi matriks untuk observasi transisi parameter secara masif dari _input_ ke konklusi.],
)

== Inline / Graphic Embedded Text

Beberapa _user manual_ mengarah pada interaksi dengan ikon aplikasi. Bila harus memberikan sinyal ke elemen GUI (seperti tombol hapus #box(image(img.myb, height: 1.2em), baseline: 20%) ) atau navigasi ke page selanjutnya, parameter `baseline` yang dipadukan ke `#box` menyandera gambar di-level tinggi teks paragraf tersebut, mereduksi kelebihan spasi vertikal.

== Side-by-Side Descripton

Laporan akademik tingkat lanjut dan buku literatur lazim mencetak narasi tepat di bibir samping elemen visual, dengan rasio asimetris `(auto, 1fr)`.

#figure(
  grid(
    columns: (auto, 1fr),
    gutter: 1.5em,
    align: (center, left + horizon),
    image(img.myb, height: 6.5cm),
    [
      *Bagan 3.3* — *Log Transformation Method.* Image asli ini menunjukkan distribusi frekuensi warna yang rapat (*dark shadow*). Dengan menyelaraskan text log (naratif) di blok sebelahnya, pembaca tidak perlu melakukan scroll / _jump page_ ke panel halaman lain. Opsi penataan ini (kiri-gambar, kanan-tulisan) mengadopsi _layout_ dari jurnal konverensi yang _dense_, efektif mengurangi redudansi ruang putih (white space) kosong.
    ],
  ),
  caption: [Layout paralel di mana observasi detail ditempatkan memanjang di sisi ruang kosong _image_.],
) <fig-sidebyst>

== Two-Block Content

Ini adalah wujud variasi dari layout kolom asimetris di atas. Ketika menyusun hipotesis dan evaluasi, pisahkan dua blok murni (teks vs. teks) yang disejajarkan rata tengah menjadi *Two Block Column*.

#grid(
  columns: (1fr, 1fr),
  gutter: 2em,
  [
    *Blok I: Model Theoretical* \
    Latar belakang *Point Processing* mendefinisikan perubahan intensitas berdasarkan relasi $s = T(r)$ secara independent di masing-masing piksel. Algoritma harus berjalan efisien (kalang nested-loop), sehingga operasi *Arithmetic Logic* tingkat lanjut sangat cocok sebagai engine fundamental.
  ],
  [
    *Blok II: Result Analysis* \
    Pengujian kompilasi *C++ OpenCV* mengemukakan penurunan execution time (latency). Di _channel_ gray-scale luminositas ($0.21R + 0.71G + 0.07B$), kecepatan konversi mengungguli average method. Terbukti efisien dalam *change detection* di antara dua matriks input yang berurutan.
  ]
)

== Multi-Column Document

Jika paper / referensi laporan ditujukan ke seminar akademik formal (seperti IEEE), membelah lebar halaman menjadi dua atau lebih _columns_ akan di-_inject_ langsung ke core parser. Blok paragraf di bawah ini menerapkan `columns(2)`.

#block(
  columns(2, gutter: 1.5em)[
    *Background Research*

    Transformasi spatial berfokus pada area operasi yang meminimalisasi perhitungan per _convolution mask_, namun mengedepankan interpolasi pada satu _point interval_.

    #colbreak()
    Dalam penyusunan framework berbasis array ini (misalnya mask 3x3), batas nilai *saturate cast* memecah masalah *buffer overflow* ke interval valid 8-bit (0-255 RGB), memastikan citra *negative* bebas distorsi di spektrum tertinggi.
  ]
)

== Blockquote Terpusat

_Padding_ horizontal berguna mengisolasi baris pernyataan yang mengutip literasi ilmiah atau konklusi wawancara:

#pad(x: 2em)[
  *Insight Utama Observasi:* "Sistem _Bit-plane slicing_ secara mengejutkan membuktikan bahwa 4-bit tertinggi (MSB) menyimpan sebagian vital energi visual, sehingga 50% data di plane sisanya (_low-tier noise_) mampu dibuang untuk menunjang skema _image compression_."
]

== Alert Box / Callouts berwarna

Opsi membuat peringatan fungsional ke dalam sebuah kontainer _box_ tebal:

#rect(
  width: 100%,
  fill: rgb("f8f9fa"), // Gray ultra-light
  stroke: (left: 4pt + rgb("dc3545")), // Red warning line
  inset: 12pt,
)[
  *Kesalahan Sistematis:* \
  Menghapus ekstensi bit ke-$N$ beresiko merusak format *Memory Safety* dari pointer variabel. Sebelum memanggil `#include <opencv>`, compiler C++ butuh CMake linkage ke library sistem yang komprehensif, atau fatal error akan mendadak freeze eksekusi *buffer array*.
]

== Orientasi Landscape

Trik merebahkan (rotate 90 derajat) sebuah canvas halaman (_Flipped page_) untuk mencetak layout diagram yang lebar dan melebihi standar ukuran A4 Portrait.

#page(flipped: true)[
  = Dokumen Lampiran Tambahan
  Porsi halaman ini memaksakan _overflow rendering_ untuk melebarkan lebar grid kerja di horizontal axis. Sering dimanfaatkan pada gambar skematik jaringan sirkuit elektronik maupun desain infrastruktur server multi-node.

  #figure(
    grid(
      columns: 3,
      gutter: 1em,
      image(img.my, height: 12cm),
      image(img.myb, height: 12cm),
      image(img.my, height: 12cm),
    ),
    caption: [Visual di-_stretch_ sesuai dimensi landscape agar detail per layer grafik mudah diidentifikasi observer.],
  )
]
