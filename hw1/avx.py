import cv2
import numpy as np
import time

kernel1=np.array([    #二維陣列 3x3
    [200,200,200],
    [200,200,200],
    [200,200,200]
])

kernel2=np.array([    #二維陣列  9x9
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2],
    [2,2,2,2,2,2,2,2,2]
])

kernel3 = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))

range1=100000

im = cv2.imread('C:\\Users\\USER\\Desktop\\vscode\\course\\hw1\\background1.jpg',0)
im=cv2.resize(im,(0,0),fx=0.5,fy=0.5)

image = cv2.medianBlur(im,3)

ret,th1 = cv2.threshold(image,100,255 ,cv2.THRESH_BINARY)


#------------------------------------------------------------------------------開啟AVX
print("使用avx執行open運算100000次")
#---------------------------3x3------------------------------------
start = time.time()

for i in range(range1):
    img=cv2.morphologyEx(th1, cv2.MORPH_OPEN, kernel3)

end = time.time()

time1=end-start

print('使用3x3的kernel的時間是',time1,'秒')
#=================9x9================================================
start = time.time()

for i in range(range1):
    img=cv2.morphologyEx(th1, cv2.MORPH_OPEN, kernel2)

end = time.time()

time1=end-start

print('使用9x9的kernel的時間是',time1,'秒')
#---------------------------------------------------------------------

#----------------------------------------------------------------------------------------關閉avx
cv2.setUseOptimized(False)
print("")
print("關閉avx執行open運算10000次")

start = time.time()

for i in range(range1):
    img=cv2.morphologyEx(th1, cv2.MORPH_OPEN, kernel3)

end = time.time()

time1=end-start

print('使用3x3的kernel的時間是',time1,'秒')
#=================9x9================================================
start = time.time()

for i in range(range1):
    img=cv2.morphologyEx(th1, cv2.MORPH_OPEN, kernel2)

end = time.time()

time1=end-start

print('使用9x9的kernel的時間是',time1,'秒')
#---------------------------------------------------------------------