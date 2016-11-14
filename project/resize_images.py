"""resize images

Resize the given set of images to a common standard size (256x256), (512,512)
"""
import os
import cv2
import pdb

imgPath = './Images/test/'
outDir = './Resize/test/'

def resize(imgFile, dim):
    img = cv2.imread(imgFile)
    resize_img = cv2.resize(img, dim)
    return resize_img

if __name__ == '__main__':
    # pdb.set_trace()
    for root, dirs, files in os.walk(imgPath):
        for name in files:
            if name.startswith('.'):
                print("Ignoring file : ", name)
                continue
            try:
                folder = root.split('/')[-1]
                fpath = os.path.join(root, name)
                print("Resizing file... ", fpath)
                img = resize(fpath, (256, 256))
                
                outPath = os.path.join(outDir, folder)
                fname = os.path.join(outPath, name)

                if not os.path.exists(outPath):
                    os.makedirs(outPath)

                cv2.imwrite(fname, img)
            except Exception as e:
                print("error: ", e)
                continue