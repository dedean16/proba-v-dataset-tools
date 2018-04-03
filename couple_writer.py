#!/usr/bin/env python3

import os
import numpy as np
from libtiff import TIFF

# Write tile array to image file (16bit tiff)
def couple_writer(tile, cnt, jx, jy, ch, level, coord):
    
    # Convert to unsigned 16bit integer
    utile = tile.astype('uint16')
    
    #==========================================================#
    # Normalize image
    # We shouldn't be doing this in the final run, but it makes
    # it a lot easier to actually read the images, as the maxima
    # of most images are well below the maximum of 2^16
    utile = (utile * (2**16 / np.max(utile))).astype('uint16')
    #==========================================================#
    
    # Construct path string
    pathstr = 'slices/{}/{}_{}/{}{}_{}'.format(level, coord[0], coord[1], jx, jy, ch)
    filestr = '{}-.tiff'.format(cnt)
    
    # Create folder if it doesn't exist yet
    if not os.path.exists(pathstr):
        os.makedirs(pathstr)
    
    # Open image file and write
    tiff = TIFF.open('{}/{}'.format(pathstr, filestr), mode='w')
    tiff.write_image(utile)
    tiff.close()


# Slice tiles from HDF5 files
# Iterate over tile indices and channels, and call couple_writer
def couple_slicer(f, ind, couplecfg, cnt, coord):
    
    # Determine level type
    try:
        f['LEVEL2A']
        level = 'LEVEL2A'
    except:
        level = 'LEVEL3'
    
    ixs, iys = ind                # Unpack calculated tile indices
    
    # Loop over indices, over channels
    for jx in range(len(ixs)-1):
        for jy in range(len(iys)-1):
            for ch in couplecfg['channels']:
                for fullimg in f[level+'/RADIOMETRY/'+ch].items():
                    # This will contain only one item, named either TOA or TOC
                    
                    # Extract tile as numpy array
                    tile = fullimg[1][ iys[jx]:iys[jx+1], ixs[jx]:ixs[jx+1] ]
                    
                    # Ignore empty images
                    if np.max(tile) > -1:
                        couple_writer(tile, cnt, jx, jy, ch, level, coord)
    return
