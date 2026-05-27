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

  auto level = (1 << src_a.elemSize1() * 8) - 1; // max level;
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
