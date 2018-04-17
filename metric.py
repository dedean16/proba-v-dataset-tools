#!/usr/bin/env python3
# Metric

import os, glob
from libtiff import TIFF

from videoquality.ssim import ssim_exact
from videoquality.vifp import vifp_mscale

from videoquality.psnr import psnr
from paths import *

# Iterate over subfolders in SR results folder
for root, dirs, files in os.walk(paths['srresults']):
    pattern = os.path.join(root, '*.tif')
    files = glob.glob(pattern)
    
    # Compute metrics if image pair is found
    if len(files) >= 2:
        
        # Open the files
        img1 = TIFF.open(files[0], mode='r').read_image()
        img2 = TIFF.open(files[1], mode='r').read_image()
        
        # Compute metrics
        MAX = 2**16-1
        impsnr = psnr(img1, img2)
        imssim = ssim_exact(img1/MAX, img2/MAX)
        imvifp = vifp_mscale(img1, img2)
        
        # Show results
        print('PSNR = {:.2f}, SSIM = {:.4f}, VIFP = {:.3f}'.format(impsnr, imssim, imvifp))
