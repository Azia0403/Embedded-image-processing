import cv2
import numpy as np

kernel1=np.array([    #二維陣列
    [200,200,200],
    [200,200,200],
    [200,200,200]
])
kernel2=np.ones((20,20),np.uint8)

im = cv2.imread('course\\background1.jpg',0)
im=cv2.resize(im,(0,0),fx=0.5,fy=0.5)

image = cv2.medianBlur(im,3)

ret,th1 = cv2.threshold(image,100,255 ,cv2.THRESH_BINARY)
cv2.imshow("Ief",th1)
cv2.waitKey(0)

erosion1=cv2.erode(th1,kernel2,iterations=1)
cv2.imshow("Ief2",erosion1)
cv2.waitKey(0)
 
dilate1=cv2.dilate(th1,kernel2,iterations=1)
cv2.imshow("Ief1",dilate1)
cv2.waitKey(0)

opening = cv2.morphologyEx(th1, cv2.MORPH_OPEN, kernel2)
cv2.imshow("Ief3",opening)
cv2.waitKey(0)


closing = cv2.morphologyEx(th1, cv2.MORPH_CLOSE, kernel2)
cv2.imshow("Ief4",closing)
cv2.waitKey(0)

