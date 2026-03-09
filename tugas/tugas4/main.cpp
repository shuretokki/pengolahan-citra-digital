#include "opencv2/core/saturate.hpp"
#include "spdlog/spdlog.h"
#include <numeric>
#include <opencv2/opencv.hpp>
#include <sciplot/sciplot.hpp>

using namespace cv;
using namespace spdlog;
using namespace sciplot;

int mirror(int i, int max) {
  if (i < 0)
    return -i;
  if (i >= max)
    return 2 * max - i - 2;
  return i;
}

void processHistogram(const Mat &src, const std::string &out, int index) {
  std::string suffix = "_" + std::to_string(index);
  int totalPixels = src.rows * src.cols;

  std::vector<int> h[3];
  for (auto i = 0; i < 3; ++i)
    h[i].assign(256, 0);
  for (auto y = 0; y < src.rows; ++y) {
    for (auto x = 0; x < src.cols; ++x) {
      Vec3b p = src.at<Vec3b>(y, x);
      h[0][p[0]]++;
      h[1][p[1]]++;
      h[2][p[2]]++;
    }
  }

  double sum[3] = {0, 0, 0};
  std::vector<uchar> lut[3];
  for (auto i = 0; i < 3; ++i)
    lut[i].resize(256);
  for (int i = 0; i < 256; ++i) {
    sum[0] += static_cast<double>(h[0][i]) / totalPixels;
    sum[1] += static_cast<double>(h[1][i]) / totalPixels;
    sum[2] += static_cast<double>(h[2][i]) / totalPixels;
    lut[0][i] = saturate_cast<uchar>(255 * sum[0]);
    lut[1][i] = saturate_cast<uchar>(255 * sum[1]);
    lut[2][i] = saturate_cast<uchar>(255 * sum[2]);
  }

  Mat eq = src.clone();
  for (auto y = 0; y < eq.rows; ++y) {
    for (auto x = 0; x < eq.cols; ++x) {
      Vec3b &p = eq.at<Vec3b>(y, x);
      for (auto i = 0; i < 3; ++i)
        p[i] = lut[i][p[i]];
    }
  }

  std::vector<int> eqH[3];
  for (auto i = 0; i < 3; ++i)
    eqH[i].assign(256, 0);
  for (auto y = 0; y < eq.rows; ++y) {
    for (auto x = 0; x < eq.cols; ++x) {
      Vec3b p = eq.at<Vec3b>(y, x);
      eqH[0][p[0]]++;
      eqH[1][p[1]]++;
      eqH[2][p[2]]++;
    }
  }

  std::vector<int> bins(256);
  std::iota(bins.begin(), bins.end(), 0);

  auto createPlot = [&](const std::vector<int> hist[3],
                        const std::string &title) {
    Plot2D p;
    p.xlabel("Gray levels");
    p.ylabel("No. of pixels");
    p.xrange(0.0, 255.0);
    p.drawCurve(bins, hist[0]).label("B").lineColor("blue").lineWidth(2);
    p.drawCurve(bins, hist[1]).label("G").lineColor("green").lineWidth(2);
    p.drawCurve(bins, hist[2]).label("R").lineColor("red").lineWidth(2);
    p.legend().title(title).atOutsideTopRight();
    return p;
  };

  Figure f1 = {{createPlot(h, "")}};
  Canvas c1 = {{f1}};
  c1.size(400, 300);
  c1.save(out + "histogram_og" + suffix + ".png");

  Figure f2 = {{createPlot(eqH, "")}};
  Canvas c2 = {{f2}};
  c2.size(400, 300);
  c2.save(out + "histogram_eq" + suffix + ".png");

  imwrite(out + "og" + suffix + ".png", src);
  imwrite(out + "eq" + suffix + ".png", eq);
}

int main() {
  std::string assets = ROOT "/common/assets/";
  std::string out = ROOT "/tugas/tugas4/output/";

  std::vector<std::string> inputs = {
      "tugas4-2_600x600.jpg", "tugas4-1_600x600.jpg", "tugas4-4_1024x1856.png"};
  for (size_t i = 0; i < inputs.size(); ++i) {
    Mat src = imread(assets + inputs[i]);
    if (src.empty()) {
      error("can't open or read file: {}", inputs[i]);
      continue;
    }
    processHistogram(src, out, i + 1);
  }

  Mat src = imread(assets + "tugas4-6_600x600.png");
  if (src.empty())
    return -1;
  imwrite(out + "og.png", src);

  int ks[] = {7, 15, 31};
  for (int k : ks) {
    int r = k / 2;
    std::string k_str = std::to_string(k);

    Mat boxZero = src.clone();
    for (int y = 0; y < src.rows; ++y) {
      for (int x = 0; x < src.cols; ++x) {
        Vec3f sum = {0, 0, 0};
        for (int ky = -r; ky <= r; ++ky) {
          for (int kx = -r; kx <= r; ++kx) {
            int ny = y + ky;
            int nx = x + kx;
            if (ny >= 0 && ny < src.rows && nx >= 0 && nx < src.cols) {
              Vec3b p = src.at<Vec3b>(ny, nx);
              for (int i = 0; i < 3; ++i)
                sum[i] += p[i];
            }
          }
        }
        for (int i = 0; i < 3; ++i)
          boxZero.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(sum[i] / (k * k));
      }
    }
    imwrite(out + "box_zero_k" + k_str + ".png", boxZero);

    Mat boxRep = src.clone();
    for (int y = 0; y < src.rows; ++y) {
      for (int x = 0; x < src.cols; ++x) {
        Vec3f sum = {0, 0, 0};
        for (int ky = -r; ky <= r; ++ky) {
          for (int kx = -r; kx <= r; ++kx) {
            int ny = std::clamp(y + ky, 0, src.rows - 1);
            int nx = std::clamp(x + kx, 0, src.cols - 1);
            Vec3b p = src.at<Vec3b>(ny, nx);
            for (int i = 0; i < 3; ++i)
              sum[i] += p[i];
          }
        }
        for (int i = 0; i < 3; ++i)
          boxRep.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(sum[i] / (k * k));
      }
    }
    imwrite(out + "box_rep_k" + k_str + ".png", boxRep);

    Mat boxMirror = src.clone();
    for (int y = 0; y < src.rows; ++y) {
      for (int x = 0; x < src.cols; ++x) {
        Vec3f sum = {0, 0, 0};
        for (int ky = -r; ky <= r; ++ky) {
          for (int kx = -r; kx <= r; ++kx) {
            int ny = mirror(y + ky, src.rows);
            int nx = mirror(x + kx, src.cols);
            Vec3b p = src.at<Vec3b>(ny, nx);
            for (int i = 0; i < 3; ++i)
              sum[i] += p[i];
          }
        }
        for (int i = 0; i < 3; ++i)
          boxMirror.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(sum[i] / (k * k));
      }
    }
    imwrite(out + "box_mirror_k" + k_str + ".png", boxMirror);
  }

  double sigmas[] = {1.0, 2.5, 5.0};
  for (double sigma : sigmas) {
    int k = ceil(6 * sigma);
    if (k % 2 == 0)
      k++;
    int r = k / 2;
    std::string s_str = (sigma == 2.5) ? "2_5" : std::to_string((int)sigma);
    std::vector<std::vector<double>> kernel(k, std::vector<double>(k));
    double sum_k = 0;
    for (int ky = -r; ky <= r; ++ky) {
      for (int kx = -r; kx <= r; ++kx) {
        double val = exp(-(kx * kx + ky * ky) / (2 * sigma * sigma)) /
                     (2 * M_PI * sigma * sigma);
        kernel[ky + r][kx + r] = val;
        sum_k += val;
      }
    }
    for (int i = 0; i < k; ++i)
      for (int j = 0; j < k; ++j)
        kernel[i][j] /= sum_k;
    Mat gaussian = src.clone();
    for (int y = 0; y < src.rows; ++y) {
      for (int x = 0; x < src.cols; ++x) {
        Vec3d sum = {0, 0, 0};
        for (int ky = -r; ky <= r; ++ky) {
          for (int kx = -r; kx <= r; ++kx) {
            int ny = mirror(y + ky, src.rows);
            int nx = mirror(x + kx, src.cols);
            Vec3b p = src.at<Vec3b>(ny, nx);
            double w = kernel[ky + r][kx + r];
            for (int i = 0; i < 3; ++i)
              sum[i] += p[i] * w;
          }
        }
        for (int i = 0; i < 3; ++i)
          gaussian.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(sum[i]);
      }
    }
    imwrite(out + "gaussian_s" + s_str + ".png", gaussian);
  }

  {
    int k_comp = 21;
    int r_comp = k_comp / 2;
    double sigma_comp = 3.5;

    Mat boxComp = src.clone();
    for (int y = 0; y < src.rows; ++y) {
      for (int x = 0; x < src.cols; ++x) {
        Vec3f sum = {0, 0, 0};
        for (int ky = -r_comp; ky <= r_comp; ++ky) {
          for (int kx = -r_comp; kx <= r_comp; ++kx) {
            int ny = mirror(y + ky, src.rows);
            int nx = mirror(x + kx, src.cols);
            Vec3b p = src.at<Vec3b>(ny, nx);
            for (int i = 0; i < 3; ++i)
              sum[i] += p[i];
          }
        }
        for (int i = 0; i < 3; ++i)
          boxComp.at<Vec3b>(y, x)[i] =
              saturate_cast<uchar>(sum[i] / (k_comp * k_comp));
      }
    }
    imwrite(out + "comp_box_1.png", boxComp);

    std::vector<std::vector<double>> gKernel(k_comp,
                                             std::vector<double>(k_comp));
    double gSum = 0;
    for (int ky = -r_comp; ky <= r_comp; ++ky) {
      for (int kx = -r_comp; kx <= r_comp; ++kx) {
        double v = exp(-(kx * kx + ky * ky) / (2 * sigma_comp * sigma_comp)) /
                   (2 * M_PI * sigma_comp * sigma_comp);
        gKernel[ky + r_comp][kx + r_comp] = v;
        gSum += v;
      }
    }
    Mat gaussComp = src.clone();
    for (int y = 0; y < src.rows; ++y) {
      for (int x = 0; x < src.cols; ++x) {
        Vec3d sum = {0, 0, 0};
        for (int ky = -r_comp; ky <= r_comp; ++ky) {
          for (int kx = -r_comp; kx <= r_comp; ++kx) {
            int ny = mirror(y + ky, src.rows);
            int nx = mirror(x + kx, src.cols);
            Vec3b p = src.at<Vec3b>(ny, nx);
            sum += Vec3d(p[0], p[1], p[2]) * gKernel[ky + r_comp][kx + r_comp] /
                   gSum;
          }
        }
        for (int i = 0; i < 3; ++i)
          gaussComp.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(sum[i]);
      }
    }
    imwrite(out + "comp_gauss_1.png", gaussComp);
  }

  Mat srcSharpen = imread(assets + "tugas4-3_800x800.png");
  if (srcSharpen.empty())
    srcSharpen = src;
  imwrite(out + "og_sharpen.png", srcSharpen);

  Mat lap4 = srcSharpen.clone();
  int lapKernel[3][3] = {{0, 1, 0}, {1, -4, 1}, {0, 1, 0}};
  for (int y = 0; y < srcSharpen.rows; ++y) {
    for (int x = 0; x < srcSharpen.cols; ++x) {
      Vec3f sum = {0, 0, 0};
      for (int ky = -1; ky <= 1; ++ky) {
        for (int kx = -1; kx <= 1; ++kx) {
          int ny = mirror(y + ky, srcSharpen.rows);
          int nx = mirror(x + kx, srcSharpen.cols);
          Vec3b p = srcSharpen.at<Vec3b>(ny, nx);
          int w = lapKernel[ky + 1][kx + 1];
          for (int i = 0; i < 3; ++i)
            sum[i] += p[i] * w;
        }
      }
      for (int i = 0; i < 3; ++i) {
        float res = static_cast<float>(srcSharpen.at<Vec3b>(y, x)[i]) - sum[i];
        lap4.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(res);
      }
    }
  }
  imwrite(out + "sharpen_laplacian.png", lap4);

  Mat lap8 = srcSharpen.clone();
  int lap8Kernel[3][3] = {{1, 1, 1}, {1, -8, 1}, {1, 1, 1}};
  for (int y = 0; y < srcSharpen.rows; ++y) {
    for (int x = 0; x < srcSharpen.cols; ++x) {
      Vec3f sum = {0, 0, 0};
      for (int ky = -1; ky <= 1; ++ky) {
        for (int kx = -1; kx <= 1; ++kx) {
          int ny = mirror(y + ky, srcSharpen.rows);
          int nx = mirror(x + kx, srcSharpen.cols);
          Vec3b p = srcSharpen.at<Vec3b>(ny, nx);
          int w = lap8Kernel[ky + 1][kx + 1];
          for (int i = 0; i < 3; ++i)
            sum[i] += p[i] * w;
        }
      }
      for (int i = 0; i < 3; ++i) {
        float res = static_cast<float>(srcSharpen.at<Vec3b>(y, x)[i]) - sum[i];
        lap8.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(res);
      }
    }
  }
  imwrite(out + "sharpen_laplacian_8.png", lap8);

  Mat sobel = srcSharpen.clone();
  int hx[3][3] = {{-1, -2, -1}, {0, 0, 0}, {1, 2, 1}};
  int hy[3][3] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
  for (int y = 0; y < srcSharpen.rows; ++y) {
    for (int x = 0; x < srcSharpen.cols; ++x) {
      for (int i = 0; i < 3; ++i) {
        float gx = 0, gy = 0;
        for (int ky = -1; ky <= 1; ++ky) {
          for (int kx = -1; kx <= 1; ++kx) {
            int ny = mirror(y + ky, srcSharpen.rows);
            int nx = mirror(x + kx, srcSharpen.cols);
            uchar p = srcSharpen.at<Vec3b>(ny, nx)[i];
            gx += p * hx[ky + 1][kx + 1];
            gy += p * hy[ky + 1][kx + 1];
          }
        }
        sobel.at<Vec3b>(y, x)[i] = saturate_cast<uchar>(abs(gx) + abs(gy));
      }
    }
  }
  imwrite(out + "sharpen_sobel.png", sobel);

  double sigma = 3.0;
  int gk = ceil(6 * sigma);
  if (gk % 2 == 0)
    gk++;
  int gr = gk / 2;
  std::vector<std::vector<double>> gKernel(gk, std::vector<double>(gk));
  double gSum = 0;
  for (int ky = -gr; ky <= gr; ++ky) {
    for (int kx = -gr; kx <= gr; ++kx) {
      double val = exp(-(kx * kx + ky * ky) / (2 * sigma * sigma)) /
                   (2 * M_PI * sigma * sigma);
      gKernel[ky + gr][kx + gr] = val;
      gSum += val;
    }
  }
  for (int i = 0; i < gk; ++i)
    for (int j = 0; j < gk; ++j)
      gKernel[i][j] /= gSum;

  Mat unsharp = srcSharpen.clone();
  Mat highboost = srcSharpen.clone();
  double k_hb = 4.5;
  for (int y = 0; y < srcSharpen.rows; ++y) {
    for (int x = 0; x < srcSharpen.cols; ++x) {
      Vec3d blurSum = {0, 0, 0};
      for (int ky = -gr; ky <= gr; ++ky) {
        for (int kx = -gr; kx <= gr; ++kx) {
          int ny = mirror(y + ky, srcSharpen.rows);
          int nx = mirror(x + kx, srcSharpen.cols);
          Vec3b p = srcSharpen.at<Vec3b>(ny, nx);
          blurSum += Vec3d(p[0], p[1], p[2]) * gKernel[ky + gr][kx + gr];
        }
      }
      for (int i = 0; i < 3; ++i) {
        double mask =
            static_cast<double>(srcSharpen.at<Vec3b>(y, x)[i]) - blurSum[i];
        unsharp.at<Vec3b>(y, x)[i] =
            saturate_cast<uchar>(srcSharpen.at<Vec3b>(y, x)[i] + mask);
        highboost.at<Vec3b>(y, x)[i] =
            saturate_cast<uchar>(srcSharpen.at<Vec3b>(y, x)[i] + k_hb * mask);
      }
    }
  }
  imwrite(out + "sharpen_unsharp.png", unsharp);
  imwrite(out + "sharpen_highboost.png", highboost);

  return 0;
}