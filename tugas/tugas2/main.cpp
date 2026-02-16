#include "opencv2/highgui.hpp"
#include "spdlog/spdlog.h"
#include <opencv2/opencv.hpp>
#include <print>

using std::print;
using namespace cv;
using namespace spdlog;

int main() {
  const std::string assets = ROOT "/common/assets/";
  auto img8 = imread(assets + "tugas2.png", IMREAD_UNCHANGED);
  if (img8.empty()) {
    error("Image file not found");
    return -1;
  }

  /*//
    (2); 2.4.1 sampling
      M (rows) x N (cols)
  *///
  print("{} x {}\n", img8.rows, img8.cols);

  /*//
    (3); 2.4.1 quantization
      L = 2 ^ bits(k)

      1  bit = 2 levels
      8  bit = 256 levels
      16 bit = 65536 levels
  *///
  print("{} gray levels\n", 1 << img8.elemSize1() * 8);

  /*//
    elemSize1() return size of one color value;
      1 byte = 8  bits(k) = 0 - 255
      2 byte = 16 bits(k) = 0 - 65535
      4 byte = 32 bits(k) = float
  *///
  print("{} byte or ", img8.elemSize1());
  print("{} bits per channel\n", img8.elemSize1() * 8);
  print("{} totals", img8.total());

  /*//
    channels();
      Grayscale = IMREAD_GRAYSCALE = 1
      BGR = IMREAD_COLOR = 3
      BGRA = IMREAD_UNCHANGED (could be 1/3/4 tho) = 4
  *///
  print("{} channels\n", img8.channels());

  /*//
    (1); display image
      imshow(winname, mat)
      waitKey(delay)
  *///
  imshow("_", img8);
  while (true)
    if (waitKey(0) == 27)
      break;

  cv::destroyAllWindows();
  return 0;
}