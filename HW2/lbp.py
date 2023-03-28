import cv2
import numpy as np
import matplotlib.pyplot as plt
import time
from skimage.feature import local_binary_pattern
from sklearn.metrics.pairwise import euclidean_distances
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.metrics.pairwise import manhattan_distances
# LBP算法实现函数
def lbp(img, radius, neighbors):
    height, width = img.shape[:2]
    # 创建与原始图像相同大小的图像，用于存储LBP特征图
    lbp_img = np.zeros((height, width), dtype=np.uint8)
    for i in range(radius, height-radius):
        for j in range(radius, width-radius):
            # 提取中心像素点周围的像素值
            center = img[i, j]
            values = []
            for k in range(neighbors):
                x = i + int(round(radius * np.cos(2 * np.pi * k / neighbors)))
                y = j - int(round(radius * np.sin(2 * np.pi * k / neighbors)))
                values.append(img[x, y])
            # 将比中心像素点大的像素值标记为1，否则标记为0，并按顺序排列成一个二进制数，该数就是该像素点的LBP值
            lbp_code = 0
            for k in range(neighbors):
                if values[k] >= center:
                    lbp_code += 2 ** k
            lbp_img[i, j] = lbp_code
    # 计算LBP特征直方图
    hist = cv2.calcHist([lbp_img], [0], None, [256], [0, 256])

    return hist.flatten()


img = cv2.imread('p1\\way.jpg', 0)
img=cv2.resize(img,(1600,1000))


img1=img[900:1000,1500:1600]
img2=img[900:1000,:100]
cv2.imshow('img',img)
cv2.imshow('img1',img2)
cv2.imshow('img2',img1)
cv2.waitKey(0)
lbp1= local_binary_pattern(img1, 8, 1) 
lbp_feature = np.histogram(lbp1, bins=256)[0]
lbp2= local_binary_pattern(img2, 8, 1) 
lbp_feature1 = np.histogram(lbp2, bins=256)[0]

#歐式距離
distance = euclidean_distances(lbp_feature.reshape(1, -1), lbp_feature1.reshape(1, -1))
print('歐基里德距離: ',distance) 
#餘弦角
similarity = cosine_similarity([lbp_feature], [lbp_feature1])[0][0]
print('餘弦角 similarity: ', similarity)
#曼哈頓
distance = manhattan_distances([lbp_feature], [lbp_feature1])[0][0]
print('曼哈頓距離: ', distance)






# 显示LBP特征直方图
plt.hist(lbp_feature, bins=256, range=[0, 256])
plt.hist(lbp_feature1, bins=256, range=[0, 256])
plt.show()
cv2.waitKey(0)
