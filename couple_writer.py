#!/usr/bin/env python3
"""
Slice tiles from HDF5 files and write to image files.

couple_writer -- Write array to image file, in tiles directory structure.
couple_slicer -- Slice arrays of data from HDF5s and pass onto couple_writer.
"""

import os
import numpy as np

from custom_functions import ensure_folders_if
from couple_cfg import couplecfg
from pngtools import writegreypng


def file_error_exit(f):
    """On file error, show message with filename and exit."""
    print('Error when reading file:')
    print(f.filename)
    print('This could be caused by a corrupt file.')
    exit()


# Write tile array to image file (16bit png) or quality mask (boolean)
def couple_writer(tile, hdfcnt, jx, jy, ch, level, coord,
                  filepath, targetpath, dtype):
    """Write array to image file, in tiles directory structure."""
    isbool = (dtype == 'bool')          # Is image of datatype boolean

    # Bitshift values; these are generally quite low, much lower than 2^16
    utile = (tile << couplecfg['valuebitshift']).astype(dtype)

    if not(isbool):                     # Normalize 16-bit images
        utilenorm = (utile * (2**16 / np.max(utile))).astype('uint16')

    # Construct path and file strings
    dirpath, filename = os.path.split(filepath)
    try:
        # Use original filename (without PROBAV_ prefix and extension)
        # N.B.: couple_collect relies on these files to have the same
        #       name as the corresponding HDF5 files!
        filestr = filename[7:-5] + '.png'
    except:
        print('Invalid file name pattern:\n' + filepath)
        return

    # Construct path strings
    pathstr = '{}/{}/{}_{}/{}{}_{}'\
              .format(targetpath, level, coord[0], coord[1], jx, jy, ch)
    pathstrorig = pathstr + couplecfg['origdir']
    pathstrnorm = pathstr + couplecfg['normdir']
    filepathstrorig = '{}/{}'.format(pathstrorig, filestr)
    filepathstrnorm = '{}/{}'.format(pathstrnorm, filestr)

    # Create folders if required
    ensure_folders_if(pathstrorig, couplecfg['orig'])
    ensure_folders_if(pathstrnorm, couplecfg['norm'] and not isbool)

    # === Write images === #
    if isbool:                          # Write boolean image (quality mask)
        writegreypng(utile, filepathstrorig)
    else:
        if couplecfg['orig']:           # Write originally scaled image file
            writegreypng(utile, filepathstrorig)

        if couplecfg['norm']:           # Write normalized image file
            writegreypng(utilenorm, filepathstrnorm)


# === Slice tiles from HDF5 files === #
# Iterate over tile indices and channels, and call couple_writer
def couple_slicer(f, ind, hdfcnt, coord, targetpath):
    """Slice arrays of data from HDF5s and pass onto couple_writer."""
    # Determine level type
    try:
        f['LEVEL2A']
        level = 'LEVEL2A'
    except:
        level = 'LEVEL3'

    ixs, iys = ind                # Unpack calculated tile indices
    imgcnt = 0

    # === Tile extraction and file writing === #
    # Iterated over tile indices
    for jx in range(len(ixs)-1):
        for jy in range(len(iys)-1):
            # Fetch quality mask channel
            try:
                # Extract quality mask tile
                qmask = f[level + couplecfg['qualitychannel']]
                qtile = qmask[iys[jy]:iys[jy+1], ixs[jx]:ixs[jx+1]]

                # Prepare True and False base images
                T = np.full(qtile.shape, True)
                F = np.full(qtile.shape, False)

                # Extract 'clear' and good bits and construct boolean image
                # Note: (x & binarynum) allows 'selection' of relevant bits:
                #       1 -> 'select' and (x == binarynum) evaluates
                #       those bits. 0 for 'unselected' bits.
                cleartile = np.where((qtile & 0b1100111) == 0b1100000, T, F)

                # If unsufficient clear pixels, skip writing images
                if cleartile.sum()/cleartile.size < couplecfg['min_clearance']:
                    continue

                # Iterate over channels
                for ch in couplecfg['channels']:
                    for fullimg in f[level+'/RADIOMETRY/'+ch].items():
                        # This will contain only one item: TOA or TOC

                        # Extract tile as numpy array
                        tile = fullimg[1][iys[jy]:iys[jy+1], ixs[jx]:ixs[jx+1]]

                        couple_writer(tile, hdfcnt, jx, jy, ch, level, coord,
                                      f.filename, targetpath, 'uint16')
                        imgcnt += 1

                # Write 'clearance' boolean image to file
                ch = couplecfg['qmaskname']
                couple_writer(cleartile, hdfcnt, jx, jy, ch, level, coord,
                              f.filename, targetpath, 'bool')
                imgcnt += 1

            except (KeyError, RuntimeError):
                file_error_exit(f)

    return imgcnt
