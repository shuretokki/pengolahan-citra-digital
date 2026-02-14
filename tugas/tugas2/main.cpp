#include "opencv2/highgui.hpp"
#include "spdlog/spdlog.h"
#include <opencv2/opencv.hpp>
#include <print>
using namespace spdlog;
using std::print;

int main() {
  const std::string assets = ROOT "/common/assets/";
  info("");
  info("TODO[1]: display image");
  info("TODO[2]: display M x N");
  info("TODO[3]: display L");

  cv::Mat img8 = cv::imread(assets + "tugas2.png", cv::IMREAD_UNCHANGED);
  if (img8.empty()) {
    error("Image file not found");
    return -1;
  }

  /*
    [2]; 2.4.1 sampling
    M (rows) x N (cols)
  */
  print("{} x {}\n", img8.rows, img8.cols);

  /*
    [3]; 2.4.1 quantization
    L = 2 ^ bits(k)

    1  bit = 2 levels
    8  bit = 256 levels
    16 bit = 65536 levels
  */
  print("{} gray levels\n", 1 << img8.elemSize1() * 8);

  /*
    elemSize1() return size of one color value
      1 byte = 8  bits(k) = 0 - 255
      2 byte = 16 bits(k) = 0 - 65535
      4 byte = 32 bits(k) = float
  */
  print("{} byte or ", img8.elemSize1());
  print("{} bits per channel\n", img8.elemSize1() * 8);

  /*
    elemSize() return size of one pixel;
      means if one channel is 4 bytes,
      then elemSize() would return
      12 bytes for 3 channel or 16
      bytes for 4 channel

    GRAYSCALE = IMREAD_GRAYSCALE = 1
    BGR = IMREAD_COLOR = 3
    BGRA = IMREAD_UNCHANGED (could be 1/3/4 tho) = 4
  */
  print("{} channels\n", img8.channels());

  /*
    [1]; display image
    imshow(winname, mat)
    waitKey(delay)
  */
  cv::imshow("_", img8);
  while (true)
    if (cv::waitKey(0) == 27)
      break;

  cv::destroyAllWindows();
  return 0;
}