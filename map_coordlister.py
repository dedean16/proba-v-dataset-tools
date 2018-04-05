#!/usr/bin/env python3

# Import h5py but suppress warning
import warnings
with warnings.catch_warnings():
    warnings.simplefilter('ignore')
    import h5py

import os, glob


# Return a list of unique coordinates contained in the database
def coordlister(paths, mapcfg):
    
    # Construct HDF5 database iterator
    pattern = os.path.join(paths['data'], '**/*.[Hh][Dd][Ff]5')
    it = glob.iglob(pattern, recursive = True)

    # Initialise coordinate list
    uniROIdata = []
    allROIdata = []
    
    nerr = 0
    
    # Iterate over all HDF5 files
    for filepath in it:
        try:
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
                ROI = {
                    'coord':    coord,
                    'iprod':    iprod,
                    'filepath': filepath
                }
                
                # Add ROI data to full list
                allROIdata.append(ROI)
                
                # If unique, add ROI data to unique list
                if not(ROI in uniROIdata):
                    uniROIdata.append(ROI)        # Add to ROIdata

        # Check if any file loading errors occur
        except OSError:
            nerr += 1
            print('Error loading file! (total errors: {})\n'.format(nerr))
        
    return allROIdata, uniROIdata
