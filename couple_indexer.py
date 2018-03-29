#!/usr/bin/env python3

from extra_math import *

def couple_indexer(f, coord, couplecfg):
    
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
    
    #=== Calculate tile pixel coordinates ===#
    # Several image tiles can be extracted from a single location
    
    # Fetch tiling configuration variables
    ch = couplecfg['chunksize']
    ntx = couplecfg['ntilesx']
    nty = couplecfg['ntilesy']
    
    # Calculate lower left corner
    startlon = coord[1] - (ntx * ch) / 2
    startlat = coord[0] - (nty * ch) / 2
    
    # Calculate tile corner pixel coordinates
    xs = [int(lon2x( startlon + tx*ch )) for tx in range(ntx)]
    ys = [int(lat2y( startlat + ty*ch )) for ty in range(nty)]
    
    return (xs, ys)
