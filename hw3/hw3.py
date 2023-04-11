import cv2
import numpy as np
from skimage.feature import local_binary_pattern
from sklearn.metrics.pairwise import manhattan_distances
import time

def Compare(lbp_feature1):
    n=0
    print("---")
    for col in range(img.shape[1]-win_size+1, 0, -win_size):
        for row in range(img.shape[0]-win_size+1, 0, -win_size):    
        # 從原始圖像中取出當前窗口的子圖像
            sub_img = gray[row:row+win_size, col:col+win_size]  
            lbp1= local_binary_pattern(sub_img, 8, 1)
            lbp_feature = np.histogram(lbp1, bins=256)[0]
            distance = manhattan_distances([lbp_feature], [lbp_feature1])[0][0]
            print('曼哈頓距離: ', distance)
            if (distance==0 ):
                img[row:row+win_size, col:col+win_size] =[0,0,0]
                gray[row:row+win_size, col:col+win_size]=0
                markers[row:row+win_size, col:col+win_size]=1
            elif (distance<1600 and distance!=0):
                n=n+1
                lbp_feature3=lbp_feature
                img[row:row+win_size, col:col+win_size] =[0,0,0]
                gray[row:row+win_size, col:col+win_size] =0
                markers[row:row+win_size, col:col+win_size]=1
          
    if(n==0):
        return
    Compare(lbp_feature3)
    return
    


# 讀取图像
img = cv2.imread('course\\hw3\\way.jpg')
#img = cv2.resize(img, (1200, 800), interpolation=cv2.INTER_NEAREST)
img=cv2.resize(img,(1500,800))
result = img.copy()#分水嶺
markers = np.zeros((img.shape[0],img.shape[1]),dtype=np.int32)
cv2.imshow('Window1', img)



#lbp = local_binary_pattern(img, n_points, radius)

gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
img1=gray[700:800,0:100]   #參考視窗
cv2.imshow('Window', img1)
cv2.waitKey(0)
start = time.time()
lbp2= local_binary_pattern(img1, 8, 1) 
lbp_feature0 = np.histogram(lbp2, bins=256)[0]

win_size=100    



Compare(lbp_feature0)

markers[0:100, :100]=2
markers[0:100, 1400:1500]=2


markers = cv2.watershed(img,markers)
img[markers == -1] = [255,0,0]

# 可視化分割结果

result[markers == 1] = [0, 0, 255]  # 前景
result[markers == 2] = [255, 0, 0]  #後景
cv2.imshow('Segmentation Result', result)
cv2.imshow('Window', img)
end = time.time()
time1=end-start
print('執行時間:',time1)
cv2.waitKey(0)
