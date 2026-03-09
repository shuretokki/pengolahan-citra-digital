= BAB IV \ MANAJEMEN DAFTAR PUSTAKA DAN SITASI

== Overview Format Referensi

Typst terintegrasi secara _native_ dengan sistem _bibliography_ tanpa _overhead_ seperti kombinasi `biber/bibtex` di editor LaTeX lama. Penulis hanya butuh me-_link_ satu repository berakhiran `.bib` konvensional.

Struktur di `refs.bib` selalu dimulai dengan kategori (_book_, _article_), kemudian _cite-key_ unik yang akan di-_call_ di dokumen utama:

```bib
@book{gonzalez2018,
  author    = {Rafael C. Gonzalez and Richard E. Woods},
  title     = {Digital Image Processing},
  edition   = {4},
  publisher = {Pearson},
  year      = {2018},
}

@article{ieee2025framework,
  author    = {{IEEE}},
  title     = {Comprehensive Framework for Intelligent Software},
  journal   = {IEEE Xplore},
  year      = {2025},
}
```

== Prosedur Sitasi

Tidak memerlukan `#import` atau deklarasi _package_ apapun. Tarik _cite-key_ langsung bersama simbol at `@` tanpa kurawal.

"Teknik *Point Processing* memberikan dasar fundamental pada analisis per-pixel. Teori modifikasi historis telah terangkum sejak versi lawas algoritma tersebut secara global @gonzalez2018. Pengembangan berujung pada standard *Software Engineering* di industri komersial internasional @ieee2025framework."

Ketika kompilasi *PDF* berjalan (build), _tags_ itu akan bertransformasi menjadi label referensi (seperti `[1]` atau `[2]`).

Untuk _citation_ yang spesifik hingga ke ranah bab atau halaman, tambahkan *brackets*: `@gonzalez2018[p. 45]`. Untuk penyebutan nama pengarang secara gramatikal (seperti "Menurut nama (2018), ..."), _execute function citation_ dengan tipe naratif: `#cite(<gonzalez2018>, form: "prose")`.

== Configuration Style

Modul Typst menguasai ratusan `style` referensi akademik:
/ `ieee`: Mencetak nomor kurung siku (bracket) numerikal `[1]`, `[2]`. Standar default industri *Engineering* dan *Computer Science*.
/ `apa`: Standar asosiasi psikologi yang formatnya `(Author, Year)`. Mendominasi paper sains liberal dan sosial.
/ `chicago-author-date`: Pendekatan *Chicago Manual of Style*.
/ File Kustom (`.csl`): _Citation Style Language_. Berisi _rules xml_ spesifik dari target Jurnal / *Conference* kampus.

== Memanggil Daftar Referensi di Ekor Laporan

Ketika semua `#cite` atau `@` sudah tersebar di paragraf-paragraf _body document_, taruh penutup daftar bacaan ini pada hirarki *file root* terbawah laporan Anda (`contoh_laporan.typ` contohnya).

```typst
#bibliography("refs.bib", style: "ieee", title: [DAFTAR PUSTAKA])
```

*Keuntungan Engine:* Typst memilki compiler pintar di mana aplikasi secara _exclusive_ hanya merender entri file `.bib` pada dokumen yang benar-benar tersitasi. File `.bib` dengan isi ribuan literasi riset akan di-_ignore_ sistem bila *cite-key* nya tidak ada dalam paragraf.
