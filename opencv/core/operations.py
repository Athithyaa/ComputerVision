import numpy as np
import cv2

img = cv2.imread('../images/tsukuba/imL.png')
img2 = cv2.imread('../images/cones/imL.png')

cv2.namedWindow('image');

print('image shape = ', img.shape)
print('image datatype = ', img.dtype)

# extract all channels
b, g, r = cv2.split(img)
m = cv2.merge((b, g, r))

# superimpose
k = img + img2[0:288, 0:384,:]
k = cv2.addWeighted(img, .5, img2[0:288, 0:384,:], .5, 0)

cv2.imshow('image', k)
cv2.waitKey(0)
cv2.destroyAllWindows()