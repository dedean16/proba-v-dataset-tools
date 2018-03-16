#!/usr/bin/env python3
import os
import glob
import h5py

# Function that returns a list of unique coordinates contained in the database
def coordlister(paths, mapcfg):
    # Construct HDF5 database iterator
    pattern = os.path.join(paths['data'], '**/*.[Hh][Dd][Ff]5')
    it = glob.iglob(pattern, recursive = True)

    # Initialise coordinate list
    ROIdata = []
    
    # Iterate over all HDF5 files
    for filepath in it:
        with h5py.File(filepath, 'r') as f:
            
            # Determine product by matching product list items against filepath string
            for product in mapcfg['products']:
                if product in filepath:
                    break
                
            else:
                # Product not found
                product = ''
            
            iprod = mapcfg['products'].index(product)
            
            # Read min/max longitude/lattitude
            lon1 = f['lon'][0]
            lon2 = f['lon'][-1]
            lat1 = f['lat'][0]
            lat2 = f['lat'][-1]
            
            # Construct ROI info
            coord = (lon1, lon2, lat1, lat2)
            ROI = {'coord': coord, 'iprod':iprod}
            
            # Add ROI data if unique
            if not(ROI in ROIdata):
                ROIdata.append(ROI)        # Add to ROIdata
        
    return ROIdata
