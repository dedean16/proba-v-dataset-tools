#!/usr/bin/env python3

import h5py
from progress.bar import ShadyBar

from custom_functions import *
from couple_cfg import *
from map_cfg import *
from couple_coords import *
from couple_filepaths import *
from couple_indexer import *
from couple_writer import *

# Get list of all files for all coords
CC, nfiles = couplepaths(coords, mapcfg)

# Initialise file counter, progress bar and processed coords list
cnt = 0
bar = ShadyBar('Processing files... ETA: %(eta)ds', max=nfiles, width=25)
coordsdone = []
fileerror = False

# Interate over coordinates
for C in CC:
    # Get coordinate
    coord = C['coord']
    filepaths = C['filepaths']
    
    # Iterate over filepaths for this coordinate
    for filepath in filepaths:
        try:
            with h5py.File(filepath, 'r') as f:                 # Open HDF5 file
                
                # Find tile coords, Slice tiles and write files
                ind = couple_indexer(f, coord, couplecfg)
                couple_slicer(f, ind, couplecfg, cnt, coord, paths['tiles'])
                
                # Finish up iteration
                cnt += 1                        # Count processed files
                bar.next()                      # Show progress bar
                
            coordsdone.append(coord)            # Add to list of processed coords
        
        # Break out of loops in case of file error
        except OSError:
            print('Error opening file:\n' + filepath)
            fileerror = True
            break
    
    if fileerror: break

bar.finish()                                # Finish progress bar

# Save list of processed coords if no errors occured
if not fileerror:
    print('Done processing {} files.'.format(nfiles))

    # Save list of processed coordinates
    filename = couplecfg['coordsdonefilename']              # Fetch filename
    np.save(filename, coordsdone)                           # Save file
    filesize = sizestr(os.path.getsize(filename), sep=' ')  # File size rounded
    print("Saved list of {} processed coords to '{}' ({}).\n".format(len(coordsdone), filename, filesize))
