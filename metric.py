#!/usr/bin/env python3
# Metric

import os, glob
from libtiff import TIFF

from psnr import psnr
from paths import *

for root, dirs, files in os.walk(paths['srresults']):
    pattern = os.path.join(root, '*.tif')
    files = glob.glob(pattern)
    
    if len(files) >= 2:
        img1 = TIFF.open(files[0], mode='r').read_image()
        img2 = TIFF.open(files[1], mode='r').read_image()
        
        print('PSNR = {:.2f}'.format(psnr(img1, img2)))
