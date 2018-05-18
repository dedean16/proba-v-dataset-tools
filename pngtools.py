#!/usr/bin/env python3
"""
Read and write 2D numpy arrays from/to PNG files. Supports 1-, 8- and 16-bit.

writegreypng -- Write 2D array to greyscale PNG file.
readgreypng -- Read greyscale PNG to numpy array.
"""

import numpy as np
import png


type2depth = {      # Dictionary for datatype (str) to bitdepth
    'bool': 1,
    'uint8': 8,
    'uint16': 16,
}


depth2type = {      # Dictionary for bitdepth to datatype (str)
    1: 'bool',
    8: 'uint8',
    16: 'uint16',
}


# Write greyscale PNG image
def writegreypng(array, path):
    """Write 2D array to greyscale PNG file. Accepts 1-, 8- and 16-bit."""
    dtypestr = str(array.dtype)

    # Check for valid datatype
    if dtypestr not in type2depth:
        raise ValueError('Accepted datatypes: {}. Given: {}'.format(
                            list(type2depth.keys()), dtypestr))

    # Determine bitdepth and image resolution
    bitdepth = type2depth[dtypestr]                 # bitdepth
    imgres = array.shape                            # Image resolution

    with open(path, 'wb') as f:                     # Open image file
        w = png.Writer(imgres[1], imgres[0], greyscale=True, bitdepth=bitdepth)
        w.write(f, array)                           # Write to image file


# Read greyscale PNG image
def readgreypng(path):
    """Read greyscale PNG to numpy array. Accepts 1-, 8- and 16-bit."""
    # Read data, determine bitdepth and datatype
    pngdata = png.Reader(path).asDirect()           # Read PNG data
    bitdepth = pngdata[3]['bitdepth']               # Get bitdepth
    dataclass = getattr(np, depth2type[bitdepth])   # Get dataclass

    # Check for valid bitdepth
    if bitdepth not in depth2type:
        raise ValueError('Accepted bit depths: {}. Given: {}'.format(
                            list(depth2type.keys()), bitdepth))

    array = np.vstack(map(dataclass, pngdata[2]))   # Load into numpy array
    return array
