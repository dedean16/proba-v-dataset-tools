#!/usr/bin/env python3
import numpy as np

# Couple target coordinate list to file paths
# Output: list of coordinate-pathlist dictionaries

def couplepaths(coords, mapcfg):
    # Load ROIdata containing regions and file paths
    ROIdata = np.load(mapcfg['ROIfilename'])
    
    # List of Coupled Coordinates (coupled with file list)
    CC = [None] * len(coords)
    nempty = 0                 # Counter for number of coordinates without files
    nfiles = 0

    # Search for regions in local database containing target coordinate
    for c in range(len(coords)):
        
        filepaths = []
        
        for ROI in ROIdata:
            
            # Target Coordinate  TC: (lat, lon)
            # Region Coordinates RC: (lon1, lon2, lat2, lat1)
            TC = coords[c]
            RC = ROI['coord']
            
            # Check if target coordinate is within region
            if (TC[1]>RC[0]) and (TC[1]<RC[1]) and (TC[0]<RC[2]) and (TC[0]>RC[3]):
                filepaths.append(ROI['filepath'])
                nfiles += 1
            
        nempty += (len(filepaths) == 0)     # Count coordinates without files
        CC[c] = { 'coord':TC,  'filepaths':filepaths } # Add to coupled coordinate list
        
    print("\n{} out of {} target coordinates not in local database.\n".format(nempty, len(CC)))
    
    return CC, nfiles
