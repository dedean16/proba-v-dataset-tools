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
    for ch in couplecfg['channels']:
        qmpath = qmpath.replace('_'+ch, '_'+couplecfg['qmaskname'])

    if qmpath == path:
        raise ValueError('No channel name found in path:\n{}'.format(path))

    return qmpath


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

    fsmalls = glob(path+'*_333M_*')
    flarges = glob(path+'*_100M_*')

    # Filter image sets on minimum amount small and big images
    if len(fsmalls) < buildcfg['nmin'] or len(flarges) == 0:
        continue

    # Skip Quality Mask images
    if couplecfg['qmaskname'] in path:
        ### Construct scoremask
        continue

    # Create folder for image set
    destpath = join(paths['kelvinsset'], 'imgset{:02}'.format(p))
    ensure_folders_if(destpath)

    bicubic_scores = []

    f = 0
    for fsmall in fsmalls:          # Iterate over LR tiles

        # Copy image file
        src = join(path, fsmall)
        copyfile(src, join(destpath, 'LR{:02}.png'.format(f)))
        copyfile(qmaskpath(src), join(destpath, 'QM{:02}.png'.format(f)))

        # Compute bicubic interpolation
        HR = readgreypng(flarges[0])  ### Choose best?
        LR = readgreypng(fsmall)
        bicubic = transform.rescale(LR, scale=3, order=3, mode='edge')

        # Check if shapes (image resolutions) are matching
        if bicubic.shape != HR.shape:
            raise ValueError('Shape not matching: {} and {}.\nFile: {}'
                             .format(bicubic.shape, HR.shape, fsmall))
            continue

        # Compute score of bicubic interpolation
        score = RMSE(bicubic, HR)
        bicubic_scores.append(score)

        f += 1

    # Compute median of bicubic interpolations, write to file
    bicubic_median_score = np.median(bicubic_scores)
    with open(join(destpath, buildcfg['normfilename']), 'w') as normfile:
        normfile.write('{}'.format(bicubic_median_score))

    # === To Do: === #
    # Choose best HR file
    # Copy HR file
    # Mask morphological erosion
    # Check mask coverage..?

    p += 1

bar.finish()
print('Copied {} image sets.'.format(p))
