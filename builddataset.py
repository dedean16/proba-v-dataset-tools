#!/usr/bin/env python3
"""Build dataset from coupled tiles."""

from os.path import join, relpath, isfile
from glob import glob
from shutil import copyfile

from progress.bar import IncrementalBar
from skimage.transform import downscale_local_mean, rescale
import numpy as np

from paths import paths
from couple_cfg import couplecfg
from build_cfg import buildcfg
from pngtools import readgreypng, writegreypng
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
            HRsmall = downscale_local_mean(HR, (3, 3))
            HRLRdiffs[h, l] = RMSE(HRsmall, LR)     # Difference of LR with HR

    hmindiff = HRLRdiffs.mean(1).argmin()           # Index of HR with min diff
    return fpHRs[hmindiff]                          # Return HR with min diff


print('\n=== BUILD DATASET ===')

# Construct list of processed PNG files (full paths)
pattern = join(paths['tiles'], '**{0}/'.format(couplecfg['origdir']))
imgsetpaths = glob(pattern, recursive=True)

# Prepare terminal output
print('Selection criteria:\n'
      + 'Minimum LR images per set: {}\nMinimum clear pixel coverage: {}'
      .format(buildcfg['nmin'], buildcfg['min_clearance']))
npaths = len(imgsetpaths)
bar = IncrementalBar('Processing files... ETA: %(eta)ds', max=npaths, width=25)

# Open source list file
pathsourcelist = join(paths['kelvinsset'], buildcfg['sources'])
with open(pathsourcelist, 'w') as fsourcelist:

    p = 0
    for path in imgsetpaths:                # Iterate over paths in tile folder
        bar.next()

        fpLRs = glob(path+'*_333M_*')
        fpHRs = glob(path+'*_100M_*')

        # Reject image set if not enough small and big images
        if len(fpLRs) < buildcfg['nmin'] or len(fpHRs) == 0:
            continue

        # Skip Quality Mask images
        if couplecfg['qmaskname'] in path:
            continue

        # Find best HR
        fpHR = find_best_HR(fpHRs, fpLRs)
        HR = readgreypng(fpHR)

        # Make small HR Quality Mask
        destpath = join(paths['kelvinsset'], 'imgset{:02}'.format(p))
        QMHR = readgreypng(qmaskpath(fpHR))
        QMHRsmall = 1.0 == downscale_local_mean(QMHR, (3, 3))

        # Create Source Mask
        # Note: The Source Mask represents all pixels that can in principle
        #       be resolved with SR and checked against the HR; i.e. there
        #       should be at least one LR where this pixel is 'good' and it
        #       should be good in the HR image.
        SMsmall = np.full(QMHRsmall.shape, True)
        for fpLR in fpLRs:                          # Iterate over LRs
            QMLR = readgreypng(qmaskpath(fpLR))     # Read corresponding QM
            SMsmall |= QMLR                         # Perform bitwise Or
        SMsmall &= QMHRsmall                        # Bitwise And with QMHR

        # Reject image sets if not enough clear pixels (Score Mask)
        if SMsmall.sum() / SMsmall.size < buildcfg['min_clearance']:
            continue

        # Create folder for image set, copy best HR image
        ensure_folders_if(destpath)
        copyfile(fpHR, join(destpath, 'HR.png'))

        # Create Score Mask and write it to file
        SMlarge = 1.0 == rescale(SMsmall, scale=3, order=0, mode='edge')
        writegreypng(SMlarge, join(destpath, 'scoremask.png'))  # Score Mask

        bicubic_scores = []         # Will hold scores of bicubic upscaled imgs

        f = 0
        for fpLR in fpLRs:          # Iterate over LR tiles

            # Copy LR and QM image files
            copyfile(fpLR, join(destpath, 'LR{:02}.png'.format(f)))
            copyfile(qmaskpath(fpLR), join(destpath, 'QM{:02}.png'.format(f)))

            # Compute bicubic interpolation
            LR = readgreypng(fpLR)
            bicubic = rescale(LR, scale=3, order=3, mode='edge')

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

        # Write list of source files
        sourcepath = relpath(path, start=paths['tiles'])
        fsourcelist.write('imgset{:02} : {}\n'.format(p, sourcepath))

        # === To Do: === #
        # Mask morphological erosion
        # Check mask coverage..?

        p += 1


bar.finish()
print('Copied {} image sets.'.format(p))
