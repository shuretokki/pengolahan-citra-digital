#include "opencv2/highgui.hpp"
#include "spdlog/spdlog.h"
#include <opencv2/opencv.hpp>
#include <print>
using namespace spdlog;
using std::print;

int main() {
  const std::string assets = ROOT "/common/assets/";
  info("imageinfo");
  info("TODO: [1] display image, [2] M x N, and [3] L");

  cv::Mat img8 = cv::imread(assets + "example.jpg", cv::IMREAD_UNCHANGED);
  if (img8.empty()) {
    error("Image file not found");
    return -1;
  }

  /*
    [2]
    2.4.1 sampling
    M (rows) x N (cols)
  */
  print("{} x {}\n", img8.rows, img8.cols);

  /*
    [3]
    2.4.1 quantization
    L = 2 ^ bits(k)

    1  bit = 2 levels
    8  bit = 256 levels
    16 bit = 65536 levels
  */
  print("{} gray levels\n", 1 << img8.elemSize1() * 8);

  /*
    1 byte = 8 bits(k)
  */
  print("{} byte atau ", img8.elemSize1());
  print("{} bits\n", img8.elemSize1() * 8);

  /*
    GRAYSCALE = IMREAD_GRAYSCALE = 1
    BGR       = IMREAD_COLOR = 3
    BGRA      = IMREAD_UNCHANGED (could be 1/3/4) = 4
  */
  print("{} channels\n", img8.channels());

  /*
    [1] display image
  */
  cv::imshow("_", img8);
  while (true)
    if (cv::waitKey(0) == 27)
      break;

  cv::destroyAllWindows();
  return 0;
}