= BAB I \ KONFIGURASI TEMPLATE DAN FORMAT TEKS

Bab ini menjelaskan cara mengonfigurasi template `asgReport` yang disediakan, serta memberikan referensi pemformatan teks, paragraf, dan list dalam lingkungan Typst. Panduan ini menggunakan terminologi standar untuk keperluan dokumentasi.

== Daftar Parameter Kustomisasi Template

Fungsi utama template laporan ini adalah `#asgReport.with(...)` yang berada di file `contoh_laporan.typ`. Seluruh parameter di bawah dapat dimodifikasi tanpa perlu mengedit source code template secara langsung:

=== Informasi Cover
/ `title`: Menentukan judul utama dokumen.
/ `course`: Menentukan nama mata kuliah atau topik bahasan.
/ `lecturer`: Nama dosen pengampu (mendukung penulisan gelar lengkap).
/ `nidn`: Nomor Identitas Dosen Nasional.
/ `students`: List atau array identitas student. Format penulisan: `((name: "A", id: "1"), (name: "B", id: "2"))`. Jika array hanya berisi satu student, maka teks dirender menjadi *italic* dan bold. Jika lebih dari satu, otomatis dirender sebagai table sejajar.
/ `program` & `faculty` & `university`: Informasi institusi yang dirender rata tengah di margin bagian bawah cover.
/ `year`: Tahun pembuatan dokumen.

=== Kertas, Margin, dan Tipografi
/ `paper`: Format ukuran document (default: `"a4"`).
/ `margin-top`, `margin-bottom`, `margin-left`, `margin-right`: Konfigurasi gap untuk margin kertas (default: `2.5cm`).
/ `font-family`: Array font. Jika font pertama tidak tersedia di system, Typst secara otomatis menggunakan fallback font berikutnya (default: `("Times New Roman", "Liberation Serif")`).
/ `font-size`: Base font size untuk keseluruhan text (default: `12pt`).
/ `caption-size`: Font size spesifik yang lebih kecil untuk text _caption_ gambar/tabel (default: `10pt`).
/ `table-size`: Font size spesifik untuk text di dalam sel tabel agar tidak penuh (default: `10pt`).
/ `lang`: Localization language pengaturan tanggal dan istilah bawaan (default: `"id"`).

=== Hierarki Heading dan Numbering
/ `heading-numbering`: Format penomoran untuk Bab dan Sub-bab (default: `"1.1 ."`).
/ `h1-size` hingga `h4-size`: Custom font size untuk level heading yang berbeda.
/ `h1-above` hingga `h4-below`: Vertical spacing (padding) di atas dan di bawah text heading.
/ `h1-pagebreak`: Menentukan apakah level 1 heading (Bab) secara otomatis trigger perpindahan ke page baru (default: `true`).
/ `h2-indent`, `h3-indent`: Jarak spasi horizontal sebelum angka sub-bab di-render (default: `0cm`).

== Format Dasar Tipografi

Format base typography pada Typst sangat berdekatan dengan environment Markdown. Anda dapat menggunakan asterisk untuk text *bold*, underscore untuk text _italic_, dan gabungan keduanya untuk text *_bold italic_*.

Fungsi tipografi yang lebih spesifik dapat dipanggil menggunakan awalan `#`:
- Underline: #underline("highlight garis bawah").
- Strikethrough: #strike("text yang dicoret").
- Custom highlight: #highlight(fill: yellow.lighten(60%))[text dengan background color tertentu].

Untuk penugasan yang melibatkan formula kimia atau notasi base math, Anda dapat memanggil subscript seperti H#sub[2]O, atau superscript untuk perhitungan eksponensial seperti E=mc#super[2].

== Struktur List

Beberapa style list dirender secara native tanpa indentasi rumit.

=== Bullet List
Sangat useful untuk overview parameter atau feature:
- Point processing operations
- Spatial filtering techniques
  - Linear filtering configuration
  - Nonlinear filtering (e.g., median filter)
- Frequency domain mapping

=== Numbered List
Digunakan untuk menarasikan step-by-step procedure:
+ Pemuatan image input ke dalam variable array.
+ Kalkulasi matrix transformation:
  + Perhitungan contrast stretching limit
  + Normalisasi float point ke range 8-bit
+ Penyimpanan output file.

=== Term List
Sangat efisien untuk membuat dictionary parameter atau glossary:
/ Intensity: Nilai amplitude yang merepresentasikan level kecerahan pada pixel spasial tertentu $(x, y)$.
/ Channel: Komponen color base yang menyusun keseluruhan image, umumnya RGB atau BGR.
/ Histogram: Grafik distribusi frekuensi level abu-abu dalam sebuah image.
