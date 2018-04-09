#!/usr/bin/env python3

import os, re
import numpy as np
from libtiff import TIFF

# Write tile array to image file (16bit tiff)
def couple_writer(tile, cnt, jx, jy, ch, level, coord, filepath, tilepath, couplecfg):
    
    # Convert to unsigned 16bit integer
    utile = tile.astype('uint16')
    ## Note: -1 = No Data, this should probably be taken into account later!
    
    #==========================================================#
    # Normalize image
    # We shouldn't be doing this in the final run, but it makes
    # it a lot easier to actually read the images, as the maxima
    # of most images are well below the maximum of 2^16
    utilenorm = (utile * (2**16 / np.max(utile))).astype('uint16')
    #==========================================================#
    
    # Construct path and file strings
    dirpath, filename = os.path.split(filepath)
    try:
        # Use original filename (without PROBAV_ prefix and extension)
        # N.B.: couple_collect relies on these files to have the same
        #       name as the corresponding HDF5 files!
        filestr = filename[7:-5] + '.tiff'
    except:
        print('Invalid file name pattern:\n' + filepath)
        return
    
    pathstr = '{}/{}/{}_{}/{}{}_{}'.format(tilepath, level, coord[0], coord[1], jx, jy, ch)
    pathstrorig = pathstr + couplecfg['origdir']
    pathstrnorm = pathstr + couplecfg['normdir']
    
    # Create folder for original if it doesn't exist yet
    if not os.path.exists(pathstrorig) and couplecfg['orig']:
        os.makedirs(pathstrorig)
        
    # Create folder for normalized if it doesn't exist yet
    if not os.path.exists(pathstrnorm) and couplecfg['norm']:
        os.makedirs(pathstrnorm)
        
    # Open original image file and write
    tiff = TIFF.open('{}/{}'.format(pathstrorig, filestr), mode='w')
    tiff.write_image(utile)
    tiff.close()
    
    # Open original image file and write
    tiff = TIFF.open('{}/{}'.format(pathstrnorm, filestr), mode='w')
    tiff.write_image(utilenorm)
    tiff.close()


# Slice tiles from HDF5 files
# Iterate over tile indices and channels, and call couple_writer
def couple_slicer(f, ind, couplecfg, cnt, coord, tilepath):
    
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
                try:
                    for fullimg in f[level+'/RADIOMETRY/'+ch].items():
                        # This will contain only one item, named either TOA or TOC
                        
                        # Extract tile as numpy array
                        tile = fullimg[1][ iys[jy]:iys[jy+1], ixs[jx]:ixs[jx+1] ]
                        
                        # Ignore empty images
                        # Note: -1 = No Data
                        if np.max(tile) > 0:
                            couple_writer(tile, cnt, jx, jy, ch, level, coord, f.filename, tilepath, couplecfg)
                    
                except (KeyError, RuntimeError):
                    print('Error when reading file:')
                    print(f.filename)
                    print('This could be caused by a corrupt file.')
                    exit()
    return
