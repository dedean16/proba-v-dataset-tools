#!/usr/bin/env python3
from scipy.interpolate import interp1d

# Construct degree to/from pixel mapping functions
def mappers(lon1, lon2, nlon, lat1, lat2, nlat):
    
    # Construct linear degree to pixel coordinate mapper
    lon2x = interp1d([lon1, lon2], [0, nlon])
    lat2y = interp1d([lat1, lat2], [0, nlat])
    def deg2pix(deg): return (int(lat2y(deg[0])), int(lon2x(deg[1])))
    # def deg2pix(lat, lon): return lat2y(lat), lon2x(lon)
    # deg2pix = lambda lat,lon: (lat2y(lat), lon2x(lon))
    
    # Construct linear pixel to degree coordinate mapper
    x2lon = interp1d([0, nlon], [lon1, lon2])
    y2lat = interp1d([0, nlat], [lat1, lat2])
    def pix2deg(p): return (y2lat(p[0]), x2lon(p[1]))
    # def pix2deg(y, x): return y2lat(y), x2lon(x)
    # pix2deg = lambda y,x: (y2lat(y), x2lon(x))
    
    return(deg2pix, pix2deg)


def couple_indexer(f, coord, couplecfg):
    
    # Retrieve index/coordinate conversion
    # Convert coordinate to index
    # Calculate start and end indices
    
    # Fetch sizes
    nlon = f['lon'].shape[0]
    nlat = f['lat'].shape[0]
    
    # Read min/max longitude/lattitude
    lon1 = f['lon'][0]
    lon2 = f['lon'][-1]
    lat1 = f['lat'][0]
    lat2 = f['lat'][-1]
    
    # Construct degree to/from pixel mapping functions with lon. and lat. info
    deg2pix, pix2lat = mappers(lon1, lon2, nlon, lat1, lat2, nlat)
    
    # c = deg2pix(coord)
    
    # Several image tiles can be extracted from a single location
    #=== Calculate tile pixel coordinates ===#
    
    # Fetch tiling configuration variables
    ch = couplecfg['chunksize']
    ntx = couplecfg['ntilesx']
    nty = couplecfg['ntilesy']
    
    # Calculate lower left corner
    startlon = coord[1] - (ntx * ch) / 2
    startlat = coord[0] - (nty * ch) / 2
    
    xs = [startlon+tx*ch for tx in range(ntx)]
    ys = [startlat+ty*ch for ty in range(nty)]
    
    # Determine level type
    try:
        f['LEVEL2A']
        level = 'LEVEL2A'
    except:
        level = 'LEVEL3'
    
    return
