import cv2
import numpy as np
import rect
import argparse
import sys
import time

parser = argparse.ArgumentParser()
parser.add_argument('sourceFile', help="path to source file.", type=str)
parser.add_argument('saveFile', help="path to save file.", type=str)
parser.add_argument('width', help="width of save file.", type=int)
parser.add_argument('height', help="height of save file.", type=int)
args = parser.parse_args()

sourceFile = args.sourceFile
saveFile = args.saveFile
w = args.width
h = args.height

image = cv2.imread(sourceFile)


orig = image.copy()

gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (5, 5), 0)

edged = cv2.Canny(blurred, 0, 50)
orig_edged = edged.copy()

image2, contours, hierarchy = cv2.findContours(edged, cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
contours = sorted(contours, key=cv2.contourArea, reverse=True)

for c in contours:
    p = cv2.arcLength(c, True)
    approx = cv2.approxPolyDP(c, 0.02 * p, True)

    if len(approx) == 4:
        target = approx
        break

approx = rect.rectify(target)
pts2 = np.float32([[0,0],[w,0],[w,h],[0,h]])

M = cv2.getPerspectiveTransform(approx,pts2)
dst = cv2.warpPerspective(orig,M,(w,h))

# cv2.drawContours(image, [target], -1, (0, w/2, 0), 2)
# cv2.imshow("ss",image)




cv2.imwrite(saveFile,dst)
sys.stdout.write(saveFile)

# if sys.platform == "win32":
#    import os, msvcrt
#    msvcrt.setmode(sys.stdout.fileno(),os.O_BINARY)
# sys.stdout.write(dst)



cv2.waitKey(0)
cv2.destroyAllWindows()

