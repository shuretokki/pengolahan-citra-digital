import cv2
import numpy as np

grid = np.array([
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 1, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 1, 0, 0],
    [0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 1, 1, 1, 1, 0, 0, 0, 0],
    [0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 1, 1, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
], dtype=np.uint8)

se = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
dilation = cv2.dilate(grid, se)
erosion = cv2.erode(grid, se)
opening = cv2.morphologyEx(grid, cv2.MORPH_OPEN, se)
closing = cv2.morphologyEx(grid, cv2.MORPH_CLOSE, se)

print(dilation, "\n=DILATION\n")
print(erosion, "\n=EROSION\n")
print(opening, "\n=OPENING\n")
print(closing, "\n=CLOSING\n")
