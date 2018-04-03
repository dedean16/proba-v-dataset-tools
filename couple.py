#!/usr/bin/env python3

import h5py

from couple_cfg import *
from map_cfg import *
from couple_coords import *
from couple_filepaths import *
from couple_indexer import *
from couple_writer import *

CC, npaths = couplepaths(coords, mapcfg)

cnt = 0

for C in CC:
    
    # Get coordinate
    coord = C['coord']
    filepaths = C['filepaths']
    
    for filepath in filepaths:
        with h5py.File(filepath, 'r') as f:
            ind = couple_indexer(f, coord, couplecfg)
            couple_slicer(f, ind, couplecfg, cnt, coord)
            
            cnt += 1
            print('{}/{} files processed'.format(cnt, npaths))
            
        # Retrieve data from selected chunk
        # Write data as image file, with unique identifiable file name (original hdf5 name + indices + channel?)
        # Repeat for all hdf5 files corresponding to this image
        # Register coordinate as 'done'
