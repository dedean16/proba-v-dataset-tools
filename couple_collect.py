#!/usr/bin/env python3

import sys, os, glob

from paths import *
from map_cfg import *
from couple_cfg import *
from couple_coords import *
from collect_cfg import *
from collect_credentials import *
from collect_wgetthread import *


# Construct list of processed tiff files (full paths)
pattern   = os.path.join(paths['tiles'], '**/*.tiff')
filepaths = glob.glob(pattern, recursive = True)

# Construct set of unique HDF5 filenames and concatenate to single string
fileset   = set(map(lambda x: ',*' + os.path.split(x)[1][:-5] + '.HDF5', filepaths))
filesdone = ''.join(fileset)

# Parse optional argument 'all' for downloading all
if len(sys.argv) > 1:
    if sys.argv[1] == 'all':
        filesdone = ''          # Filter no files


threads = []                    # Initialise thread collection

# Start wget threads
for c in coords:
    for product in cfg['products']:
        
        # Modify coordinates
        cfg['ROI']['xll'] = c[1]
        cfg['ROI']['yll'] = c[0]
        cfg['ROI']['xur'] = c[1]
        cfg['ROI']['yur'] = c[0]
        
        # Start thread
        th = wgetthread(cfg, paths, product, filesdone)
        threads.append(th)
        th.start()

# Monitor wget status
status = wgetstatus(paths, len(fileset))
threads.append(status)
status.start()

# Wait for all threads to finish
for th in threads:
    th.join()
