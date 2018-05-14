#!/usr/bin/env python3

import os, re
import numpy as np
from libtiff import TIFF

import png

from couple_cfg import *


def file_error_exit(f):
    print('Error when reading file:')
    print(f.filename)
    print('This could be caused by a corrupt file.')
    exit()


# Write tile array to image file (16bit tiff)
def couple_writer(tile, hdfcnt, jx, jy, ch, level, coord, filepath, targetpath, dtype):
    
    notbool = (dtype != 'bool_')
    
    # Convert to unsigned 16bit integer
    utile = tile.astype(dtype)
    ## Note: -1 = No Data, this should probably be taken into account later!
    
    #==========================================================#
    # Normalize image
    # We shouldn't be doing this in the final run, but it makes
    # it a lot easier to actually read the images, as the maxima
    # of most images are well below the maximum of 2^16
    if notbool:
        utilenorm = (utile * (2**16 / np.max(utile))).astype('uint16')
    #==========================================================#
    
    # Construct path and file strings
    dirpath, filename = os.path.split(filepath)
    try:
        # Use original filename (without PROBAV_ prefix and extension)
        # N.B.: couple_collect relies on these files to have the same
        #       name as the corresponding HDF5 files!
        filestr = filename[7:-5]
    except:
        print('Invalid file name pattern:\n' + filepath)
        return
    
    pathstr = '{}/{}/{}_{}/{}{}_{}'.format(targetpath, level, coord[0], coord[1], jx, jy, ch)
    pathstrorig = pathstr + couplecfg['origdir']
    pathstrnorm = pathstr + couplecfg['normdir']
    
    
    # Create folder for original if it doesn't exist yet
    if not os.path.exists(pathstrorig) and couplecfg['orig']:
        os.makedirs(pathstrorig)
        
    # Create folder for normalized if it doesn't exist yet
    if not os.path.exists(pathstrnorm) and couplecfg['norm'] and notbool:
        os.makedirs(pathstrnorm)
    
    
    if couplecfg['orig'] and notbool:   # Open original image file and write
        tiff = TIFF.open('{}/{}.tif'.format(pathstrorig, filestr), mode='w')
        tiff.write_image(utile)
        tiff.close()
        
    if couplecfg['norm'] and notbool:   # Open normalized image file and write
        tiff = TIFF.open('{}/{}.tif'.format(pathstrnorm, filestr), mode='w')
        tiff.write_image(utilenorm)
        tiff.close()
    
    
    if not(notbool):
        # print(type(utile))
        # tiff = Image.fromarray(utile)
        # tiff.save('{}/{}'.format(pathstr, filestr))
        
        imgres = utile.shape
        with open('{}/{}.png'.format(pathstrorig, filestr), 'wb') as f:
            w = png.Writer(imgres[1], imgres[0], greyscale=True, bitdepth=1)
            w.write(f, utile)

    
    
# Slice tiles from HDF5 files
# Iterate over tile indices and channels, and call couple_writer
def couple_slicer(f, ind, hdfcnt, coord, targetpath):
    
    # Determine level type
    try:
        f['LEVEL2A']
        level = 'LEVEL2A'
    except:
        level = 'LEVEL3'
    
    ixs, iys = ind                # Unpack calculated tile indices
    imgcnt = 0
    
    #=== Tile extraction and file writing ===#
    # Iterated over tile indices
    for jx in range(len(ixs)-1):
        for jy in range(len(iys)-1):
            # Fetch quality mask channel
            try:
                # Extract quality mask tile
                qmask = f[level + couplecfg['qualitychannel']]
                qtile = qmask[ iys[jy]:iys[jy+1], ixs[jx]:ixs[jx+1] ]
                
                # Extract 'clear' bits and construct boolean image
                T = np.full(qtile.shape, True)
                F = np.full(qtile.shape, False)
                cleartile = np.where( (qtile & 0b111) == 0b000, T, F )
                
                # If sufficient clear pixels, write images
                if cleartile.sum() / cleartile.size > couplecfg['min_clearance']:
                
                    # Iterate over channels
                    for ch in couplecfg['channels']:
                        for fullimg in f[level+'/RADIOMETRY/'+ch].items():
                            # This will contain only one item, named either TOA or TOC
                            
                            # Extract tile as numpy array
                            tile = fullimg[1][ iys[jy]:iys[jy+1], ixs[jx]:ixs[jx+1] ]
                            
                            couple_writer(tile, hdfcnt, jx, jy, ch, level, coord, f.filename, targetpath, 'uint16')
                            imgcnt += 1
                        
                    
                    # Write 'clearance' boolean image to file
                    couple_writer(cleartile, hdfcnt, jx, jy, 'QMASK', level, coord, f.filename, targetpath, 'bool_')
                    imgcnt += 1
                    
            except (KeyError, RuntimeError):
                file_error_exit(f)
            
    return imgcnt
