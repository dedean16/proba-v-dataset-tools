#!/usr/bin/env python3

import os
import glob

from skimage import transform

from paths import paths
from couple_cfg import couplecfg
from build_cfg import buildcfg
from extra_math import RMSE
from pngtools import readgreypng

# Count images in set
# Compute bicubic interpolation errors
# Write bicub. intp. normalization factor


# Construct list of processed PNG files (full paths)
pattern = os.path.join(paths['tiles'], '**{0}/'.format(couplecfg['origdir']))
imgsetpaths = glob.glob(pattern, recursive=True)

for path in imgsetpaths:
    fsmalls = glob.glob(path+'*_333M_*')
    flarges = glob.glob(path+'*_100M_*')

    # Filter image sets on minimum amount small and big images
    if len(fsmalls) >= buildcfg['nmin'] and len(flarges) > 0:
        for fsmall in fsmalls:
            LR = readgreypng(fsmall)
            bicubic = transform.rescale(LR, 3, 3, mode='edge')

            ###
            HR = readgreypng(flarges[0])
            if bicubic.shape == HR.shape:
                print(RMSE(bicubic, HR))
            else:
                print('Shape not matching: {} - {}'.format(bicubic.shape, HR.shape))
                print(RMSE(bicubic[:767, :767], HR[:767, :767]))
