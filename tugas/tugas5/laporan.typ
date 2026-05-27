#import "../laporan/asp.typ": asp, subfig

#let SL_MARK = "sublabel-marker"
#show figure.where(kind: image): it => {
  show figure.caption: c => {
    set text(size: 10pt)
    set par(leading: 1.1em)
    let body = c.body
    let sl-data = none

    if body.has("children") {
      for child in body.children {
        if (
          child.func() == metadata
            and type(child.value) == dictionary
            and child.value.at("kind", default: none) == SL_MARK
        ) {
          sl-data = child.value
          break
        }
      }
    } else if (
      body.func() == metadata and type(body.value) == dictionary and body.value.at("kind", default: none) == SL_MARK
    ) {
      sl-data = body.value
    }

    if sl-data != none {
      let c_cols = if sl-data.cols == none { sl-data.labels.len() } else { sl-data.cols }
      let sl-grid = grid(
        columns: (auto,) * c_cols,
        gutter: 0.2em,
        ..sl-data.labels.map(it => box(
          fill: luma(240),
          radius: 0pt,
          inset: 2pt,
          stroke: 0pt,
          text(size: 8pt, font: "Times New Roman", it),
        ))
      )

      set align(left)
      grid(
        columns: (auto, 1fr),
        gutter: 1em,
        align: top,
        sl-grid, [ *#c.supplement #c.counter.display(c.numbering):* #body ],
      )
    } else {
      set align(center)
      [ *#c.supplement #c.counter.display(c.numbering):* #body ]
    }
  }
  it
}

#let sublabel(cols: none, ..args) = metadata((
  kind: SL_MARK,
  cols: cols,
  labels: args.pos(),
))

#show: asp.with(
  lang: "id",
  type: emph("LAPORAN TUGAS"),
  cover: (
    type-pos: "top",
  ),
  title: "PENGOLAHAN CITRA BERWARNA",
  course: "Pengolahan Citra Digital",
  lecturer: (name: "Dr. Ir. Ricky Eka Putra, S.Kom., M.Kom.", id: "198701162018031001"),
  students: (
    (name: "Tri Rianto Utomo", id: "24051204104"),
  ),
  program: "Teknik Informatika",
  faculty: "Teknik",
  university: "Universitas Negeri Surabaya",
  year: "2026",
)

#pagebreak()
#h(0pt)

= PENDAHULUAN

Model warna RGB dan CMY/CMYK adalah ruang yang berorientasi pada perangkat keras. RGB sering kita gunakan untuk akuisisi data melalui sensor. Sementara itu, CMY/CMYK diterapkan pada luaran cetak yang memerlukan primer substraktif sekunder.

Dirancanglah ruang HSI sebagai model yang berorientasi aplikasi dengan memisahkan intensitas dari informasi warna, yakni hue dan saturasi. Pemisahan ini membentuk kerangka matematis yang selaras dengan mata manusia. Hal ini mempermudah algoritme pemrosesan citra berbasis aras keabuan. Adapun transformasi Y'CbCr mengisolasi komponen luminansi dari krominansi. Langkah ini penting. Tujuannya agar data warna dapat terdekolerasi secara efektif demi memaksimalkan efisiensi kompresi JPEG-2000.

= DASAR TEORI

== Model Warna HSI (Hue, Saturation, Intensity)
Model HSI memisahkan komponen warna dari intensitasnya. Persamaan matematis untuk ekstraksi komponen $H$, $S$, dan $I$ dari nilai RGB yang ternormalisasi $[0, 1]$ adalah sebagai berikut:

$ I = 1/3 (R + G + B) $
$ S = 1 - 3/(R + G + B) [min(R, G, B)] $
$ H = cases(theta &"jika" B <= G, 360 - theta &"jika" B > G) $

Dengan $theta$ didefinisikan sebagai:
$ theta = arccos((1/2 [(R-G) + (R-B)]) / ([ (R-G)^2 + (R-B)(G-B) ]^0.5 + epsilon)) $

== Model Warna CMY dan CMYK
Model CMY (Cyan, Magenta, Yellow) adalah pasangan komplemen dari model RGB, yang lazim digunakan pada perangkat keras luaran cetak. Hubungannya didefinisikan sebagai:

$ mat(C; M; Y) = mat(1; 1; 1) - mat(R; G; B) $

Sedangkan model CMYK menambahkan komponen Black ($K$) untuk efisiensi tinta dan akurasi warna gelap. Nilai $K$ diambil dari intensitas minimum komponen warna:
$ K = min(1-R, 1-G, 1-B) $
$ C_k = (1-R-K)/(1-K) ; M_k = (1-G-K)/(1-K) ; Y_k = (1-B-K)/(1-K) $

== Model Warna YUV dan YCbCr
Model YUV dan YCbCr memisahkan informasi kecerahan (luminositas) dari informasi warna (krominansi). YUV banyak digunakan pada sistem transmisi video analog, sementara YCbCr adalah versi digitalnya (BT.601):

$ mat(Y; U; V) = mat(0.299, 0.587, 0.114; -0.147, -0.289, 0.436; 0.615, -0.515, -0.100) mat(R; G; B) $
$
  mat(Y; "Cb"; "Cr") = mat(0.299, 0.587, 0.114; -0.1687, -0.3313, 0.5; 0.5, -0.4187, -0.0813) mat(R; G; B) + mat(0; 128; 128)
$

Hubungan YUV serupa dengan YCbCr namun dengan faktor skala yang berbeda untuk komponen U dan V guna optimalisasi bandwidth transmisi.

= IMPLEMENTASI DAN HASIL

== Implementasi Kode
#figure(
  metadata(none),
  kind: raw,
  supplement: [Kode],
  caption: [Implementasi lengkap transformasi warna dan filter spasial (main.cpp).],
)

```cpp
#include "spdlog/spdlog.h"
#include <filesystem>
#include <opencv2/opencv.hpp>
#include <opencv4/opencv2/opencv.hpp>

using namespace cv;
using namespace spdlog;
namespace fs = std::filesystem;

int main() {
  std::string assets = ROOT "/common/assets/";
  std::string out = ROOT "/tugas/tugas5/output/";
  fs::create_directories(out);

  auto src_a = imread(assets + "tugas5-1.jpg");
  if (src_a.empty()) {
    error("can't open or read file");
    return -1;
  }

  auto level = (1 << src_a.elemSize1() * 8) - 1; // max level
  Mat UC1A = Mat::zeros(src_a.size(), CV_8UC1);

  auto cmy = src_a.clone();
  for (auto y = 0; y < src_a.rows; ++y) {
    for (auto x = 0; x < src_a.cols; ++x) {
      Vec3b &p = cmy.at<Vec3b>(y, x);
      for (auto i = 0; i < 3; ++i)
        p[i] = level - p[i];
    }
  }

  std::vector<Mat> _cmy;
  split(cmy, _cmy);
  imwrite(out + "cmy_cyan.png", _cmy[2]);
  imwrite(out + "cmy_magenta.png", _cmy[1]);
  imwrite(out + "cmy_yellow.png", _cmy[0]);

  auto cyan = _cmy[2];
  auto magenta = _cmy[1];
  auto yellow = _cmy[0];
  auto black = UC1A.clone();
  for (auto y = 0; y < src_a.rows; ++y) {
    for (auto x = 0; x < src_a.cols; ++x) {
      uint8_t _c = cyan.at<uint8_t>(y, x);
      uint8_t _m = magenta.at<uint8_t>(y, x);
      uint8_t _y = yellow.at<uint8_t>(y, x);
      uint8_t _k = std::min({_c, _m, _y});

      cyan.at<uint8_t>(y, x) = _c - _k;
      magenta.at<uint8_t>(y, x) = _m - _k;
      yellow.at<uint8_t>(y, x) = _y - _k;
      black.at<uint8_t>(y, x) = _k;
    }
  }

  imwrite(out + "cmyk_cyan.png", cyan);
  imwrite(out + "cmyk_magenta.png", magenta);
  imwrite(out + "cmyk_yellow.png", yellow);
  imwrite(out + "cmyk_black.png", black);

  auto src_b = imread(assets + "tugas5-2.jpg");
  if (src_b.empty()) {
    error("can't open or read file");
    return -1;
  }

  Mat UC1B = Mat::zeros(src_b.size(), CV_8UC1);

  auto hue = UC1B.clone();
  auto saturation = UC1B.clone();
  auto intensity = UC1B.clone();
  for (auto y = 0; y < src_b.rows; ++y) {
    for (auto x = 0; x < src_b.cols; ++x) {
      Vec3b p = src_b.at<Vec3b>(y, x);

      double _p[3];
      for (auto i = 0; i < 3; ++i)
        _p[i] = p[i] / 255.0;

      double _intensity = (_p[2] + _p[1] + _p[0]) / 3.0;
      double _saturation =
          (_intensity == 0)
              ? 0
              : 1.0 - (std::min({_p[2], _p[1], _p[0]}) / _intensity);

      double _hue = 0;
      if (_saturation > 0) {
        double num = 0.5 * ((_p[2] - _p[1]) + (_p[2] - _p[0]));
        double den = std::sqrt(std::pow(_p[2] - _p[1], 2) +
                               (_p[2] - _p[0]) * (_p[1] - _p[0])) +
                     1e-6;
        double theta = std::acos(num / den) * (180.0 / M_PI);

        if (_p[0] <= _p[1])
          _hue = theta;
        else
          _hue = 360.0 - theta;
      }

      intensity.at<uint8_t>(y, x) = (uint8_t)(_intensity * 255.0);
      saturation.at<uint8_t>(y, x) = (uint8_t)(_saturation * 255.0);
      hue.at<uint8_t>(y, x) = (uint8_t)(((_hue / 360.0) * 255.0));
    }
  }

  imwrite(out + "hsi_hue.png", hue);
  imwrite(out + "hsi_saturation.png", saturation);
  imwrite(out + "hsi_intensity.png", intensity);

  auto src_c = imread(assets + "tugas5-3.jpg");
  if (src_c.empty()) {
    error("can't open or read file");
    return -1;
  }

  Mat UC1C = Mat::zeros(src_c.size(), CV_8UC1);

  auto Y = UC1C.clone();
  auto U = UC1C.clone();
  auto V = UC1C.clone();
  auto CB = UC1C.clone();
  auto CR = UC1C.clone();
  for (auto y = 0; y < src_c.rows; ++y) {
    for (auto x = 0; x < src_c.cols; ++x) {
      Vec3b p = src_c.at<Vec3b>(y, x);

      double _Y = 0.299 * p[2] + 0.587 * p[1] + 0.114 * p[0];
      double _U = -0.147 * p[2] - 0.289 * p[1] + 0.436 * p[0] + 128;
      double _V = 0.615 * p[2] - 0.515 * p[1] - 0.100 * p[0] + 128;
      double _CB = -0.1687 * p[2] - 0.3313 * p[1] + 0.5 * p[0] + 128;
      double _CR = 0.5 * p[2] - 0.4187 * p[1] - 0.0813 * p[0] + 128;

      Y.at<uint8_t>(y, x) = _Y;
      U.at<uint8_t>(y, x) = _U;
      V.at<uint8_t>(y, x) = _V;
      CB.at<uint8_t>(y, x) = _CB;
      CR.at<uint8_t>(y, x) = _CR;
    }
  }

  imwrite(out + "ycbcr_y.png", Y);
  imwrite(out + "ycbcr_cb.png", CB);
  imwrite(out + "ycbcr_cr.png", CR);
  imwrite(out + "yuv_u.png", U);
  imwrite(out + "yuv_v.png", V);

  auto src_d = imread(assets + "tugas5-4.png");
  if (src_d.empty()) {
    error("can't open or read file");
    return -1;
  }

  auto sm = src_d.clone();
  auto sp = src_d.clone();

  GaussianBlur(src_d, sm, Size(7, 7), 1.5);
  imwrite(out + "gaussian.png", sm);

  Mat kernel = (Mat_<float>(3, 3) << 0, -1, 0, -1, 5, -1, 0, -1, 0);
  filter2D(src_d, sp, -1, kernel);
  imwrite(out + "laplacian.png", sp);

  return 0;
}
```

== CMY & CMYK
#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("/common/assets/tugas5-1.jpg"), []),
    subfig(image("output/cmy_cyan.png"), []),
    subfig(image("output/cmy_magenta.png"), []),
    subfig(image("output/cmy_yellow.png"), []),
  ),
  caption: [
    #sublabel(cols: 4, "a", "b", "c", "d")
    Dekomposisi Kanal CMY: (a) Citra Asli, (b) Cyan, (c) Magenta, (d) Yellow.
  ],
)

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("/common/assets/tugas5-1.jpg"), []),
    subfig(image("output/cmyk_cyan.png"), []),
    subfig(image("output/cmyk_magenta.png"), []),

    subfig(image("output/cmyk_yellow.png"), []), subfig(image("output/cmyk_black.png"), []),
  ),
  caption: [
    #sublabel(cols: 3, "a", "b", "c", "d", "e")
    Dekomposisi Kanal CMYK: (a) Citra Asli, (b) Cyan, (c) Magenta, (d) Yellow, (e) Black.
  ],
)

== HSI
#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("/common/assets/tugas5-2.jpg"), []),
    subfig(image("output/hsi_hue.png"), []),
    subfig(image("output/hsi_saturation.png"), []),
    subfig(image("output/hsi_intensity.png"), []),
  ),
  caption: [
    #sublabel(cols: 4, "a", "b", "c", "d")
    Komponen Ruang Warna HSI: (a) Citra Asli, (b) Hue, (c) Saturation, (d) Intensity.
  ],
)

== YCbCr & YUV
#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("/common/assets/tugas5-3.jpg"), []),
    subfig(image("output/ycbcr_y.png"), []),
    subfig(image("output/ycbcr_cb.png"), []),
    subfig(image("output/ycbcr_cr.png"), []),
  ),
  caption: [
    #sublabel(cols: 4, "a", "b", "c", "d")
    Komponen Ruang Warna YCbCr: (a) Citra Asli, (b) Y (Luminance), (c) Cb (Chrominance), (d) Cr (Chrominance).
  ],
)

#figure(
  grid(
    columns: (1fr, 1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("/common/assets/tugas5-3.jpg"), []),
    subfig(image("output/ycbcr_y.png"), []),
    subfig(image("output/yuv_u.png"), []),
    subfig(image("output/yuv_v.png"), []),
  ),
  caption: [
    #sublabel(cols: 4, "a", "b", "c", "d")
    Komponen Ruang Warna YUV: (a) Citra Asli, (b) Y (Luminance), (c) U (Chrominance), (d) V (Chrominance).
  ],
)

== Filter Spasial

#figure(
  grid(
    columns: (1fr, 1fr, 1fr),
    gutter: 0.2em,
    subfig(image("/common/assets/tugas5-4.png"), []),
    subfig(image("output/gaussian.png"), []),
    subfig(image("output/laplacian.png"), []),
  ),
  caption: [
    #sublabel(cols: 3, "a", "b", "c")
    Hasil Filter Spasial: (a) Citra Asli, (b) Gaussian Blur, (c) Laplacian Sharpening.
  ],
)
