#!/usr/bin/env python3
# NDVI - Normalized Difference Vegetation Index

import os, glob
from libtiff import TIFF
from progress.bar import IncrementalBar

from paths import *
from couple_cfg import *


# Compute NDVI image from NIR and RED channels
def ndvi(nir, red):
    return (nir - red) / (nir + red)


# Map NDVI index to range of [0, 2^16)]
def ndvimap(ndviimg):
    return (0.5 + 0.5 * ndviimg) * 2**16


# Compute and write NDVI image files in the tiles directory
def compute_ndvi_tiles():
    
    # Construct list of processed tiff files (full paths)
    pattern  = os.path.join(paths['tiles'], '**/*_RED'+couplecfg['origdir']+'/*.tif')
    redpaths = glob.glob(pattern, recursive = True)
    
    print('Computing and writing NDVI from NIR and RED images.')
    bar = IncrementalBar('Processing files... ETA: %(eta)ds', max=len(redpaths), width=25)
    
    for redpath in redpaths:                        # Iterate over filepaths
        
        # Construct filepaths for NIR image and new NDVI image
        nirpath  = redpath.replace('_RED', '_NIR')
        ndvipath = redpath.replace('_RED', '_ndvi')
        
        # Read images
        try:
            imgred = TIFF.open(redpath, mode='r').read_image().astype('float32')
            imgnir = TIFF.open(nirpath, mode='r').read_image().astype('float32')
        except:
            print('Error while attempting to open image files.\n')
            
        # Compute NDVI image; map from [-1, +1] to [0, +1]
        imgndvi = ndvimap( ndvi(imgnir, imgred) ).astype('float32')
        
        # Create folders
        ndvidirpath = os.path.dirname(ndvipath)
        if not os.path.exists(ndvidirpath):         # Check if NDVI orig folder exists
            os.makedirs(ndvidirpath)                # Make orig NDVI folder
            
        origname = couplecfg['origdir'].replace('/', '')
        normname = couplecfg['normdir'].replace('/', '')
        ndvinormpath = ndvipath.replace(origname, normname) # Construct norm path
        ndvinormdirpath = os.path.dirname(ndvinormpath)
        if not os.path.exists(ndvinormdirpath):     # Check if NDVI norm folder exists
            os.makedirs(ndvinormdirpath)            # Make norm NDVI folder
            
            
        # Write NDVI images
        if couplecfg['orig']:
            # Write NDVI image (original scaling)
            tiff = TIFF.open(ndvipath, mode='w')    # Open image file for writing
            tiff.write_image(imgndvi)               # Write NDVI image to file
            tiff.close()                            # Close image file
            
        if couplecfg['norm']:
            # Write normalized NDVI image
            imgnormndvi  = imgndvi - imgndvi.min()
            imgnormndvi *= 255/imgnormndvi.max()
            tiff = TIFF.open(ndvinormpath, mode='w')
            tiff.write_image(imgnormndvi.astype('uint8')) # Write NDVI image to file
            tiff.close()                            # Close image file
        
        bar.next()
        
    bar.finish()                                    # Finish progress bar

# If this file is executed as a script
if __name__ == '__main__':
    compute_ndvi_tiles()
