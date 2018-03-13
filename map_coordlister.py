#!/usr/bin/env python3
import os
import glob
import h5py

# Function that returns a list of unique coordinates contained in the database
def coordlister(paths):
    # Construct HDF5 database iterator
    pattern = os.path.join(paths['data'], '**/*.[Hh][Dd][Ff]5')
    it = glob.iglob(pattern, recursive = True)

    # Initialise coordinate list
    coordlist = []
    
    # Iterate over all HDF5 files
    for filepath in it:
        with h5py.File(filepath, 'r') as f:
            
            # Read min/max longitude/lattitude
            lon1 = f['lon'][0]
            lon2 = f['lon'][-1]
            lat1 = f['lat'][0]
            lat2 = f['lat'][-1]
            
            # Add coordinates to list if unique
            coord = (lon1, lon2, lat1, lat2)
            if not(coord in coordlist):
                coordlist.append(coord)
        
    return coordlist
