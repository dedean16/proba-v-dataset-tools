#!/usr/bin/env python3
"""Build dataset from coupled tiles."""

from os.path import join
from glob import glob
from shutil import copyfile

from progress.bar import IncrementalBar
from skimage import transform
import numpy as np

from paths import paths
from couple_cfg import couplecfg
from build_cfg import buildcfg
from pngtools import readgreypng
from extra_math import RMSE
from custom_functions import ensure_folders_if


def qmaskpath(path):
    """Construct QMASK tiles path from channel tiles path."""
    qmpath = path
    channels = couplecfg['channels']
    channels.append('ndvi')
    for ch in channels:
        qmpath = qmpath.replace('_'+ch, '_'+couplecfg['qmaskname'])

    if qmpath == path:
        raise ValueError('No channel name found in path:\n{}'.format(path))

    return qmpath


def find_best_HR(fpHRs, fpLRs):
    """
    Determine and return HR to use, by comparing downscaled HRs with LRs.

    fpHRs -- list of filepaths of HR images
    fpLRs -- list of filepaths of LR images
    """
    HRLRdiffs = np.zeros((len(fpHRs), len(fpLRs)))
    for h in range(len(fpHRs)):                     # Iterate over HR filepaths
        for l in range(len(fpLRs)):                 # Iterate over LR filepaths
            LR = readgreypng(fpLRs[l])
            HR = readgreypng(fpHRs[h])
            HRsmall = transform.downscale_local_mean(HR, (3, 3))
            HRLRdiffs[h, l] = RMSE(HRsmall, LR)     # Difference of LR with HR

    hmindiff = HRLRdiffs.mean(1).argmin()           # Index of HR with min diff
    return fpHRs[hmindiff]                          # Return HR with min diff


# Construct list of processed PNG files (full paths)
pattern = join(paths['tiles'], '**{0}/'.format(couplecfg['origdir']))
imgsetpaths = glob(pattern, recursive=True)

print('Selection criteria:\n'
      + 'Minimum LR images per set: {}'.format(buildcfg['nmin']))
npaths = len(imgsetpaths)
bar = IncrementalBar('Processing files... ETA: %(eta)ds', max=npaths, width=25)

p = 0
for path in imgsetpaths:                # Iterate over paths in tile folder
    bar.next()

    fpLRs = glob(path+'*_333M_*')
    fpHRs = glob(path+'*_100M_*')

    # Filter image sets on minimum amount small and big images
    if len(fpLRs) < buildcfg['nmin'] or len(fpHRs) == 0:
        continue

    # Skip Quality Mask images
    if couplecfg['qmaskname'] in path:
        ### Construct scoremask
        continue

    # Create folder for image set
    destpath = join(paths['kelvinsset'], 'imgset{:02}'.format(p))
    ensure_folders_if(destpath)

    # Find best HR and copy it over to new destination
    fpHR = find_best_HR(fpHRs, fpLRs)
    HR = readgreypng(fpHR)
    copyfile(fpHR, join(destpath, 'HR.png'))

    bicubic_scores = []             # Will hold scores of bicubic upscaled imgs

    f = 0
    for fpLR in fpLRs:              # Iterate over LR tiles

        # Copy LR and QM image files
        copyfile(fpLR, join(destpath, 'LR{:02}.png'.format(f)))
        copyfile(qmaskpath(fpLR), join(destpath, 'QM{:02}.png'.format(f)))

        # Compute bicubic interpolation
        LR = readgreypng(fpLR)
        bicubic = transform.rescale(LR, scale=3, order=3, mode='edge')

        # Check if shapes (image resolutions) are matching
        if bicubic.shape != HR.shape:
            raise ValueError('Shape not matching: {} and {}.\nFile: {}'
                             .format(bicubic.shape, HR.shape, fpLR))
            continue

        # Compute score of bicubic interpolation
        score = RMSE(bicubic, HR)
        bicubic_scores.append(score)

        f += 1

    # Compute median of bicubic interpolations, write to file
    with open(join(destpath, buildcfg['normfilename']), 'w') as normfile:
        normfile.write('{}'.format(np.median(bicubic_scores)))

    # === To Do: === #
    # Mask morphological erosion
    # Check mask coverage..?

    p += 1

bar.finish()
print('Copied {} image sets.'.format(p))
