import cv2

img = cv2.imread("D:\\bw.jpeg")

img_y_cr_cb = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)
y, cr, cb = cv2.split(img_y_cr_cb)

y_eq = cv2.equalizeHist(y)

img_y_cr_cb_eq = cv2.merge((y_eq, cr, cb))
img_rgb_eq = cv2.cvtColor(img_y_cr_cb_eq, cv2.COLOR_YCR_CB2BGR)

resized_img = cv2.resize(img_rgb_eq,(0,0),fx=0.3,fy=0.3)

cv2.imshow("ddddddd",resized_img);
cv2.waitKey(0)
cv2.destroyAllWindows()
