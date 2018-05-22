#!/usr/bin/env python3
"""Build dataset from coupled tiles."""

import os
import glob

from skimage import transform
import numpy as np

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

for path in imgsetpaths:                # Iterate over paths in tile folder
    fsmalls = glob.glob(path+'*_333M_*')
    flarges = glob.glob(path+'*_100M_*')

    # Filter image sets on minimum amount small and big images
    if len(fsmalls) < buildcfg['nmin'] or len(flarges) == 0:
        continue

    # Skip Quality Mask images
    if couplecfg['qmaskname'] in path:
        continue

    bicubic_scores = []

    for fsmall in fsmalls:          # Iterate over LR tiles
        HR = readgreypng(flarges[0])  ### Choose best?
        LR = readgreypng(fsmall)
        bicubic = transform.rescale(LR, scale=3, order=3, mode='edge')

        if bicubic.shape != HR.shape:
            raise ValueError('Shape not matching: {} and {}.\nFile: {}'
                             .format(bicubic.shape, HR.shape, fsmall))
            continue

        # Compute score of bicubic interpolation
        score = RMSE(bicubic, HR)
        bicubic_scores.append(score)

    # Compute median of bicubic interpolations
    bicubic_median_score = np.median(bicubic_scores)
    print('Median:', bicubic_median_score, '\t', path.split('/')[-3:-2][0])

    # === To Do: === #
    # Copy files to new location
    # Write median of bicubic interpolation scores to textfile
    # Copy masks
    # Check mask coverage..?
