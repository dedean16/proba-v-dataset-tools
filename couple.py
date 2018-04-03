#!/usr/bin/env python3

import h5py
from progress.bar import ShadyBar

from custom_functions import *
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
            
            # Find tile coords, Slice tiles and write files
            ind = couple_indexer(f, coord, couplecfg)
            couple_slicer(f, ind, couplecfg, cnt, coord)
            
            # Finish up iteration
            cnt += 1                        # Count processed files
            bar.next()                      # Show progress bar
            
        coordsdone.append(coord)            # Add to list of processed coords

bar.finish()                                # Finish progress bar
print('Done processing {} files.'.format(nfiles))

# Save list of processed coordinates
filename = couplecfg['coordsdonefilename']
np.save(filename, coordsdone)               # Save file
filesize = sizestr(os.path.getsize(filename), sep=' ')    # File size rounded
print("Saved list of {} processed coordinates to file '{}' ({}).\n".format(len(CC), filename, filesize))
