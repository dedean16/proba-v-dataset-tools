#!/usr/bin/env python3

import h5py
from progress.bar import ShadyBar

from couple_cfg import *
from map_cfg import *
from couple_coords import *
from couple_filepaths import *
from couple_indexer import *
from couple_writer import *

# Get list of all files for all coords
CC, nfiles = couplepaths(coords, mapcfg)

# Initialise file counter, progress bar and processed coords list
cnt = 0
bar = ShadyBar('Processing files... ETA: %(eta)ds', max=nfiles, width=25)
coordsdone = []

# Interate over coordinates
for C in CC:
    # Get coordinate
    coord = C['coord']
    filepaths = C['filepaths']
    
    # Iterate over filepaths for this coordinate
    for filepath in filepaths:
        with h5py.File(filepath, 'r') as f:                 # Open HDF5 file
            ind = couple_indexer(f, coord, couplecfg)       # Find tile coords
            couple_slicer(f, ind, couplecfg, cnt, coord)    # Slice tiles, write files
            
            # Finish up iteration
            cnt += 1                        # Count processed files
            bar.next()                      # Show progress bar
            
        coordsdone.append(coord)            # Add to list of processed coords

bar.finish()                                # Finish progress bar
print('Done processing {} files.'.format(nfiles))

#### Save coordsdone
