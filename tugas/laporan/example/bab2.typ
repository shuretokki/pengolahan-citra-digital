= BAB II \ MATH EQUATION, TABLE, DAN KODE

Bab ini mendemonstrasikan bagaimana Typst memproses _math equation_, membuat _table_ kompleks maupun sederhana, serta menulis _nested loop_ dalam _code block_.

== Math Equation Bawaan

Typst merender _math symbol_ secara otomatis di antara tanda dollar `$`. Ini meminimalisasi penggunaan library yang sering wajib dipakai di LaTeX.

Sebagai contoh *inline equation*: Transformation function untuk contrast stretching memiliki base limit, $d(p, q) = sqrt((p_1 - q_1)^2 + (p_2 - q_2)^2)$. Nilai intensity harus selalu $0 <= r <= L-1$.

Untuk merender equation secara full block dan ditengah halaman, sisipkan _white space_ (spasi) sesudah karakter dollar pembuka:

$ F(u, v) = sum_(x=0)^(M-1) sum_(y=0)^(N-1) f(x, y) e^(-j 2 pi (u x / M + v y / N)) $ <eq-fourier>

Kondisi bercabang (Piecewise function) sangat umum pada algoritma filter.

$ s = T(r) = cases(
  alpha r &"jika" 0 <= r < r_1,
  beta (r - r_1) + s_1 &"jika" r_1 <= r < r_2,
  gamma (r - r_2) + s_2 &"jika" r_2 <= r <= 255
) $ <eq-piecewise>

Penulisan Matrix 3x3 untuk *linear smoothing filter mask*:

$ w = 1/9 mat(
  1, 1, 1;
  1, 1, 1;
  1, 1, 1;
) $

== Code Block

Implementasi algoritma pada environment _point processing_ sering kali dijelaskan melalui _source code snippet_. Menggunakan _backtick_ berulang seperti pada Markdown memungkinkan syntax highlighting untuk spesifik _programming language_.

Contoh implementasi C++ dengan menggunakan *array iteration*:

```cpp
#include <iostream>
#include <opencv2/opencv.hpp>

int main() {
    // 1. Membaca image (Grayscale mode)
    cv::Mat image = cv::imread("gambar.jpg", cv::IMREAD_GRAYSCALE);
    if (image.empty()) {
        std::cerr << "OpenCV Error: Unrecognized file extension." << std::endl;
        return -1;
    }

    // 2. Clone Mat untuk output buffer
    cv::Mat negative = image.clone();
    int height = image.rows;
    int width = image.cols;

    // 3. Pixel iteration dengan nested loop performatif
    for (int y = 0; y < height; ++y) {
        uchar* p = image.ptr<uchar>(y);         // Pointer basis (input)
        uchar* p_out = negative.ptr<uchar>(y);  // Pointer basis (output)

        for (int x = 0; x < width; ++x) {
            // Negative transformation: s = 255 - r
            p_out[x] = cv::saturate_cast<uchar>(255 - p[x]);
        }
    }

    cv::imshow("Original Image", image);
    cv::imshow("Negative Image", negative);
    cv::waitKey(0);
    return 0;
}
```

Variasi lain bisa menggunakan command-line `bash` script yang sangat membantu tim *DevOps* yang membaca laporan untuk men-set build argument:

```bash
#!/bin/bash
# ── Script Kompilasi OpenCV CMake ──
mkdir -p build && cd build
cmake -D CMAKE_BUILD_TYPE=Release \
      -D BUILD_EXAMPLES=OFF \
      -D OPENCV_GENERATE_PKGCONFIG=ON ..
make -j$(nproc)
sudo make install
```

== Table Alignment

Pembangunan referensi data untuk _performance benchmarking_ sangat bergantung pada layout tabel. Anda bebas men-set fill color dan custom colspan.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    stroke: 0.5pt,
    align: (center, left, center, right, center),
    [*No.*], [*Operasi Logical*], [*Formula Lanjut*], [*Latency (ms)*], [*Visual Status*],
    [1], [Bitwise AND], [$A and B$], [0.15], [Partial Merged],
    [2], [Bitwise OR], [$A \/ B$], [0.12], [Full Overlay],
    [3], [Bitwise XOR], [$A xor B$], [0.14], [Change Det.],
  ),
  caption: [Daftar komparasi latensi untuk operasi _Logical_ antar matrix.]
) <tab-simple>

== Table Berwarna

Untuk tabel log record atau dokumentasi panjang, warna selang-seling (_zebra_) menjaga kenyamanan _eye tracking_ pada baris.

#figure(
  table(
    columns: (auto, 1.2fr, 1.5fr, auto),
    fill: (col, row) => if row == 0 { luma(200) } else if calc.odd(row) { luma(240) } else { white },
    stroke: 0.5pt + luma(100),
    align: (center, left, left, center),

    [*ID*], [*Transformation Method*], [*Mathematical Formula*], [*Time Complexity*],

    [1], [Image Negative], [Reversing pixel level: $s = L - 1 - r$], [$cal(O)(N)$],
    [2], [Log Transform], [Expands lower intensity interval: $s = c log(1 + r)$], [$cal(O)(N)$],
    table.cell(rowspan: 2)[3], [Power-law (Gamma) $gamma < 1$], [Enhancement curve untuk _dark image_ (Mencerahkan)], [$cal(O)(N)$],
    [Power-law (Gamma) $gamma > 1$], [Enhancement curve untuk _bright image_ (Menggelapkan)], [$cal(O)(N)$],
    [4], [Contrast Stretching], [Piecewise linear mendongkrak _dynamic range_], [$cal(O)(N)$],
  ),
  caption: [Summary algoritma yang sering masuk dalam kelas *Point Processing*.]
) <tab-point-processing>

Seperti pada tabel @tab-point-processing di atas, instruksi `table.cell(rowspan: 2)` memaksa _layout engine_ melebur dua baris vertikal. Ini membuat baris pada bagian `Power-law (Gamma)` terangkai menjadi list ganda. Kombinasi format ini sangat krusial dalam laporan berdasar _scientific testing_ untuk menyajikan perbandingan _hyperparameter_ berulang (seperti Gamma $0.4$, dan $2.5$).
