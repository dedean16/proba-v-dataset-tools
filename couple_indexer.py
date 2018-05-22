#!/usr/bin/env python3
"""couple_indexer -- Calculate pixel indices for tile in HDF5 file."""

from numpy import arange

from extra_math import linefunc
from couple_cfg import couplecfg


def couple_indexer(f, coord):
    """Calculate pixel indices for tile in HDF5 file."""
    # Fetch sizes
    nlon = f['lon'].shape[0]
    nlat = f['lat'].shape[0]

    # Read min/max longitude/lattitude
    lon1 = f['lon'][0]
    lon2 = f['lon'][-1]
    lat1 = f['lat'][0]
    lat2 = f['lat'][-1]

    # Construct linear degree to pixel coordinate mappers
    lon2x = linefunc(lon1, lon2, 0, nlon)
    lat2y = linefunc(lat1, lat2, 0, nlat)

    # === Calculate tile pixel coordinates === #
    # Several image tiles can be extracted from a single location

    if '_100M_' in f.filename:
        scale = couplecfg['scaleHR']
    else:
        scale = 1

    # Fetch tiling configuration variables and compute center indices
    chk = couplecfg['chunksizeLR'] * scale
    nitx = couplecfg['ntilesx'] + 1             # Tile corners num of x indices
    nity = couplecfg['ntilesy'] + 1             # Tile corners num of y indices
    cx = int(lon2x(coord[1]))                   # Center x index
    cy = int(lat2y(coord[0]))                   # Center y index

    # Calculate tile corner pixel coordinates, and sort
    ixs = [int(cx + tx*chk) for tx in arange(-nitx/2, nitx/2)]
    iys = [int(cy + ty*chk) for ty in arange(-nity/2, nity/2)]

    # Indices can become negative if the target coordinate
    # is at the boundary of the satellite image.
    # Remove negative indices and out of bound indices:
    ixs = list(filter(lambda x: x >= 0 and x < nlon, ixs))
    iys = list(filter(lambda y: y >= 0 and y < nlat, iys))

    # Sort coordinate lists
    ixs.sort()
    iys.sort()

    # Return pixel coordinate lists
    return (ixs, iys)
