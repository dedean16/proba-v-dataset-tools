#!/usr/bin/env python3
"""Extract tiles from 300m/pix and 100m/pix versions from HDF5 files."""

# Import h5py but suppress warning

from progress.bar import IncrementalBar

from paths import paths
# from custom_functions import *
# from couple_cfg import couplecfg
from map_cfg import mapcfg
from couple_coords import coords
from couple_filepaths import couplepaths
from couple_indexer import couple_indexer
from couple_writer import couple_slicer

import warnings
with warnings.catch_warnings():
    warnings.simplefilter('ignore')
    import h5py


print('\n=== COUPLE ===')

# Get list of all files for all coords
CC, nfiles = couplepaths(coords, mapcfg)

targetpath = paths['tiles']
print('Target path:\n{}'.format(targetpath))

# Initialise file counter, progress bar and processed coords list
hdfcnt = 0                                      # HDF file counter
imgcnt = 0                                      # Written image file counter
bar = IncrementalBar('Processing files... ETA: %(eta)ds', max=nfiles, width=25)
fileerror = False

# Interate over coordinates
for C in CC:
    # Get coordinate
    coord = C['coord']
    filepaths = C['filepaths']

    # Iterate over filepaths for this coordinate
    for filepath in filepaths:
        try:
            with h5py.File(filepath, 'r') as f:         # Open HDF5 file

                # Find tile coords, Slice tiles and write files
                ind = couple_indexer(f, coord)
                imgcnt += couple_slicer(f, ind, hdfcnt, coord, targetpath)

                # Finish up iteration
                hdfcnt += 1                     # Count processed files
                bar.next()                      # Show progress bar

        # Break out of loops in case of file error
        except OSError:
            print('Error opening file:\n' + filepath)
            fileerror = True
            break

    if fileerror:
        break

bar.finish()                                    # Finish progress bar

# Report done if no error occurred
if not fileerror:
    print('Done processing {} files. Wrote {} image files.'
          .format(nfiles, imgcnt))
