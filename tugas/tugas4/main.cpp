#include "opencv2/core/hal/interface.h"
#include "spdlog/spdlog.h"
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace spdlog;

int main() {
  std::string assets = ROOT "/common/assets/";
  std::string out = ROOT "/tugas/tugas4/output/";
  auto og = imread(assets + "tugas4-1.jpg");
  auto pg = imread(assets + "tugas4-2.png");
  if (og.empty() || pg.empty()) {
    error("can't open or read file");
    return -1;
  }

  Mat gC1 = Mat::zeros(og.size(), CV_8UC1);
  Mat gC3 = Mat::zeros(og.size(), CV_8UC3);
  Mat pC1 = Mat::zeros(pg.size(), CV_8UC1);
  Mat pC3 = Mat::zeros(pg.size(), CV_8UC3);
  double L = (1 << og.elemSize1() * 8) - 1;

  Mat gLightness = gC1.clone();
  Mat gAverage = gC1.clone();
  Mat gLuminosity = gC1.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      int z1 = (max({p[2], p[1], p[0]}) + min({p[2], p[1], p[0]})) / 2;
      int z2 = (p[2] + p[1] + p[0]) / 3;
      int z3 = (0.21 * p[2]) + (0.71 * p[1]) + (0.07 * p[0]);
      gLightness.at<uchar>(y, x) = saturate_cast<uchar>(z1);
      gAverage.at<uchar>(y, x) = saturate_cast<uchar>(z2);
      gLuminosity.at<uchar>(y, x) = saturate_cast<uchar>(z3);
    }
  }

  Mat gNegative = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      gNegative.at<Vec3b>(y, x) = Vec3b(L - p[0], L - p[1], L - p[2]);
    }
  }

  Mat gLogT = gC3.clone();
  double c = 255.0 / std::log(1 + 255.0);
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      gLogT.at<Vec3b>(y, x) =
          Vec3b(saturate_cast<uchar>(c * std::log(1.0 + p[0])),
                saturate_cast<uchar>(c * std::log(1.0 + p[1])),
                saturate_cast<uchar>(c * std::log(1.0 + p[2])));
    }
  }

  double gammas[3] = {0.4, 1.0, 3.0};
  Mat gGamma[3] = {gC3.clone(), gC3.clone(), gC3.clone()};
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      for (int g = 0; g < 3; ++g) {
        gGamma[g].at<Vec3b>(y, x) =
            Vec3b(saturate_cast<uchar>(L * std::pow(p[0] / L, gammas[g])),
                  saturate_cast<uchar>(L * std::pow(p[1] / L, gammas[g])),
                  saturate_cast<uchar>(L * std::pow(p[2] / L, gammas[g])));
      }
    }
  }

  double rmin, rmax;
  minMaxLoc(og.reshape(1), &rmin, &rmax);
  Mat gContrast = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      gContrast.at<Vec3b>(y, x) =
          Vec3b(saturate_cast<uchar>((p[0] - rmin) * L / (rmax - rmin)),
                saturate_cast<uchar>((p[1] - rmin) * L / (rmax - rmin)),
                saturate_cast<uchar>((p[2] - rmin) * L / (rmax - rmin)));
    }
  }

  Mat gBitplane[8];
  for (int i = 0; i < 8; ++i)
    gBitplane[i] = gC1.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      int z3 = (0.21 * p[2]) + (0.71 * p[1]) + (0.07 * p[0]);
      for (int i = 0; i < 8; ++i)
        gBitplane[i].at<uchar>(y, x) = (z3 & (1 << i)) ? 255 : 0;
    }
  }

  Mat pNegative = pC3.clone();
  for (auto y = 0; y < pg.rows; ++y) {
    for (auto x = 0; x < pg.cols; ++x) {
      Vec3b p = pg.at<Vec3b>(y, x);
      pNegative.at<Vec3b>(y, x) = Vec3b(L - p[0], L - p[1], L - p[2]);
    }
  }

  Mat pLogT = pC3.clone();
  for (auto y = 0; y < pg.rows; ++y) {
    for (auto x = 0; x < pg.cols; ++x) {
      Vec3b p = pg.at<Vec3b>(y, x);
      pLogT.at<Vec3b>(y, x) =
          Vec3b(saturate_cast<uchar>(c * std::log(1.0 + p[0])),
                saturate_cast<uchar>(c * std::log(1.0 + p[1])),
                saturate_cast<uchar>(c * std::log(1.0 + p[2])));
    }
  }

  Mat pGamma[3] = {pC3.clone(), pC3.clone(), pC3.clone()};
  for (auto y = 0; y < pg.rows; ++y) {
    for (auto x = 0; x < pg.cols; ++x) {
      Vec3b p = pg.at<Vec3b>(y, x);
      for (int g = 0; g < 3; ++g) {
        pGamma[g].at<Vec3b>(y, x) =
            Vec3b(saturate_cast<uchar>(L * std::pow(p[0] / L, gammas[g])),
                  saturate_cast<uchar>(L * std::pow(p[1] / L, gammas[g])),
                  saturate_cast<uchar>(L * std::pow(p[2] / L, gammas[g])));
      }
    }
  }

  Mat gSubLSB = gC1.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      int z3 = (0.21 * p[2]) + (0.71 * p[1]) + (0.07 * p[0]);
      int lsb = z3 & 0xFE;
      gSubLSB.at<uchar>(y, x) = (z3 != lsb) ? 255 : 0;
    }
  }

  Mat lowres, lowresUp;
  resize(og, lowres, Size(), 0.5, 0.5, INTER_NEAREST);
  resize(lowres, lowresUp, og.size(), 0, 0, INTER_NEAREST);
  Mat gSubLowres = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      Vec3b r = lowresUp.at<Vec3b>(y, x);
      gSubLowres.at<Vec3b>(y, x) = Vec3b(saturate_cast<uchar>(p[0] - r[0]),
                                         saturate_cast<uchar>(p[1] - r[1]),
                                         saturate_cast<uchar>(p[2] - r[2]));
    }
  }

  Mat gSubAngio = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      Vec3b neg = gNegative.at<Vec3b>(y, x);
      gSubAngio.at<Vec3b>(y, x) = Vec3b(saturate_cast<uchar>(p[0] - neg[0]),
                                        saturate_cast<uchar>(p[1] - neg[1]),
                                        saturate_cast<uchar>(p[2] - neg[2]));
    }
  }

  Mat gAND = gC3.clone();
  Mat gOR = gC3.clone();
  Mat gXOR = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      Vec3b neg = gNegative.at<Vec3b>(y, x);
      gAND.at<Vec3b>(y, x) = Vec3b(p[0] & neg[0], p[1] & neg[1], p[2] & neg[2]);
      gOR.at<Vec3b>(y, x) = Vec3b(p[0] | neg[0], p[1] | neg[1], p[2] | neg[2]);
      gXOR.at<Vec3b>(y, x) = Vec3b(p[0] ^ neg[0], p[1] ^ neg[1], p[2] ^ neg[2]);
    }
  }

  Mat gORBitplane = gC1.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      gORBitplane.at<uchar>(y, x) =
          gBitplane[6].at<uchar>(y, x) | gBitplane[7].at<uchar>(y, x);
    }
  }

  Mat gXORSelf = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      gXORSelf.at<Vec3b>(y, x) = Vec3b(p[0] ^ p[0], p[1] ^ p[1], p[2] ^ p[2]);
    }
  }

  Mat gANDMask = gC3.clone();
  Mat mask = gC3.clone();
  circle(mask, Point(og.cols / 2, og.rows / 2), og.rows / 3,
         Scalar(255, 255, 255), -1);
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      Vec3b m = mask.at<Vec3b>(y, x);
      gANDMask.at<Vec3b>(y, x) = Vec3b(p[0] & m[0], p[1] & m[1], p[2] & m[2]);
    }
  }

  Mat gXORGamma = gC3.clone();
  for (auto y = 0; y < og.rows; ++y) {
    for (auto x = 0; x < og.cols; ++x) {
      Vec3b p = og.at<Vec3b>(y, x);
      Vec3b gam = gGamma[0].at<Vec3b>(y, x);
      gXORGamma.at<Vec3b>(y, x) =
          Vec3b(p[0] ^ gam[0], p[1] ^ gam[1], p[2] ^ gam[2]);
    }
  }

  imwrite(out + "grayscale_lightness.png", gLightness);
  imwrite(out + "grayscale_average.png", gAverage);
  imwrite(out + "grayscale_luminosity.png", gLuminosity);
  imwrite(out + "negative.png", gNegative);
  imwrite(out + "log_transform.png", gLogT);
  imwrite(out + "gamma_04.png", gGamma[0]);
  imwrite(out + "gamma_10.png", gGamma[1]);
  imwrite(out + "gamma_30.png", gGamma[2]);
  imwrite(out + "contrast_stretch.png", gContrast);
  for (int i = 0; i < 8; ++i)
    imwrite(out + "bitplane_" + std::to_string(i + 1) + ".png", gBitplane[i]);

  imwrite(out + "pg_negative.png", pNegative);
  imwrite(out + "pg_log_transform.png", pLogT);
  imwrite(out + "pg_gamma_04.png", pGamma[0]);
  imwrite(out + "pg_gamma_10.png", pGamma[1]);
  imwrite(out + "pg_gamma_30.png", pGamma[2]);

  imwrite(out + "subtract_og_vs_lsb.png", gSubLSB);
  imwrite(out + "subtract_og_vs_lowres.png", gSubLowres);
  imwrite(out + "subtract_og_vs_negative.png", gSubAngio);

  imwrite(out + "bitwise_and.png", gAND);
  imwrite(out + "bitwise_or.png", gOR);
  imwrite(out + "bitwise_or_bitplane.png", gORBitplane);
  imwrite(out + "bitwise_xor.png", gXOR);
  imwrite(out + "bitwise_xor_self.png", gXORSelf);
  imwrite(out + "bitwise_and_mask.png", gANDMask);
  imwrite(out + "bitwise_xor_gamma.png", gXORGamma);

  return 0;
}