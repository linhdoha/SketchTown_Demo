import cv2

img = cv2.imread("D:\\abc.png")


img = img*2

img = cv2.resize(img,(0,0),fx=0.5,fy=0.5)

cv2.imshow("ddddddd",img);
cv2.waitKey(0)
cv2.destroyAllWindows()
