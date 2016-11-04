import numpy as np
import cv2

# create a black image of 512x512
img = np.zeros((512,512,3), np.uint8)

# draw shapes
cv2.line(img,(0,0),(511,511),(0,255,0), 3)
cv2.rectangle(img,(384,10),(510,128),(0,0,255), 3)

# negative thickness will fill the shape
cv2.circle(img,(447,163), 63, (255,0,25), -1)

pts = np.array([[10,5],[20,30],[70,20],[50,10]], np.int32)
pts = pts.reshape((-1,1,2))
cv2.polylines(img,[pts],True,(0,255,255))

font = cv2.FONT_HERSHEY_SIMPLEX
cv2.putText(img,'OpenCV',(10,500), font, 4,(255,255,255),2)

cv2.imshow('image', img)
cv2.waitKey(0)
cv2.destroyAllWindows()
