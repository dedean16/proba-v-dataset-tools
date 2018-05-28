#!/usr/bin/env python3
"""
NDVI - Normalized Difference Vegetation Index.

ndvi -- Compute Normalized Difference Vegetation Index.
ndvimap -- Map NDVI range to uint16 range.
compute_ndvi_tiles -- Compute and write NDVI for images in the tiles folder.
"""

import os
import glob
from progress.bar import IncrementalBar

from custom_functions import ensure_folders_if
from pngtools import readgreypng, writegreypng
from paths import paths
from couple_cfg import couplecfg


# Compute NDVI image from NIR and RED channels
def ndvi(nir, red):
    """Compute Normalized Difference Vegetation Index from NIR & RED images."""
    return (nir - red) / (nir + red)


# Map NDVI index to range of [0, 2^16)]
def ndvimap(ndviimg):
    """Map NDVI range [-1, +1] to uint16 range [0, 2^16-1]. Returns uint16."""
    return ((0.5 + 0.5 * ndviimg) * 2**16-1).astype('uint16')


# Compute and write NDVI image files in the tiles directory
def compute_ndvi_tiles():
    """Compute and write NDVI for images in the tiles folder."""
    # Construct list of processed png files (full paths)
    pattern = os.path.join(paths['tiles'], '**/*_RED'
                           + couplecfg['origdir'] + '/*.png')
    redpaths = glob.glob(pattern, recursive=True)

    print('Computing and writing NDVI from NIR and RED images.')
    bar = IncrementalBar('Processing files... ETA: %(eta)ds',
                         max=len(redpaths), width=25)

    for redpath in redpaths:                        # Iterate over filepaths
        # Construct filepaths for NIR image and new NDVI image
        nirpath = redpath.replace('_RED', '_NIR')
        ndvipath = redpath.replace('_RED', '_ndvi')

        # Read images
        try:
            imgred = readgreypng(redpath).astype('float32')
            imgnir = readgreypng(nirpath).astype('float32')
        except:
            print('Error while attempting to open image files.\n')

        # Compute NDVI image; map from [-1, +1] to [0, +1]
        imgndvi = ndvimap(ndvi(imgnir, imgred))

        # Construct file names and file paths
        origname = couplecfg['origdir'].replace('/', '')
        normname = couplecfg['normdir'].replace('/', '')
        ndvidirpath = os.path.dirname(ndvipath)
        ndvinormpath = ndvipath.replace(origname, normname)
        ndvinormdirpath = os.path.dirname(ndvinormpath)

        ensure_folders_if(ndvidirpath)
        ensure_folders_if(ndvinormdirpath)

        # Write NDVI images
        if couplecfg['orig']:
            # Write NDVI image (original scaling)
            writegreypng(imgndvi, ndvipath)

        if couplecfg['norm']:
            # Write normalized NDVI image
            imgnormndvi = imgndvi - imgndvi.min()
            imgnormndvi *= 255/imgnormndvi.max()
            writegreypng(imgnormndvi.astype('uint8'), ndvinormpath)

        bar.next()

    bar.finish()                                    # Finish progress bar


# If this file is executed as a script
if __name__ == '__main__':
    print('\n=== NDVI ===')
    compute_ndvi_tiles()
