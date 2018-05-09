#!/usr/bin/env python3

# Import h5py but suppress warning
import warnings
with warnings.catch_warnings():
    warnings.simplefilter('ignore')
    import h5py

from progress.bar import IncrementalBar

from paths import *
from custom_functions import *
from couple_cfg import *
from map_cfg import *
from couple_coords import *
from couple_filepaths import *
from couple_indexer import *
from couple_writer import *

# Get list of all files for all coords
CC, nfiles = couplepaths(coords, mapcfg)

targetpath = paths['tiles']
print('Target path: {}'.format(targetpath))

# Initialise file counter, progress bar and processed coords list
cnt = 0
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
            with h5py.File(filepath, 'r') as f:                 # Open HDF5 file
                
                # Find tile coords, Slice tiles and write files
                ind = couple_indexer(f, coord)
                couple_slicer(f, ind, cnt, coord, targetpath)
                
                # Finish up iteration
                cnt += 1                        # Count processed files
                bar.next()                      # Show progress bar
                
        # Break out of loops in case of file error
        except OSError:
            print('Error opening file:\n' + filepath)
            fileerror = True
            break
    
    if fileerror: break

bar.finish()                                # Finish progress bar

# Report done if no error occurred
if not fileerror: print('Done processing {} files.'.format(nfiles))
