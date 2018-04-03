#!/usr/bin/env python3

import sys

from paths import *
from map_cfg import *
from couple_cfg import *
from couple_coords import *
from couple_filepaths import *
from collect_cfg import *
from collect_credentials import *
from collect_wgetthread import *

CC, nfiles = couplepaths(coords, mapcfg)

# Parse optional argument 'all' for downloading all
downloadall = False
if len(sys.argv) > 1:
    if sys.argv[1] == 'all':
        downloadall = True
    
# Load list of processed coordinates (processed by couple.py)
if os.path.exists(couplecfg['coordsdonefilename']):
    coordsdone = np.load(couplecfg['coordsdonefilename'])
else:
    coordsdone = ()

# Initialise thread collection
threads = []

# Start wget threads
for C in CC:
    for product in cfg['products']:
        
        if (len(C['filepaths']) == 0 and not C['coord'] in coordsdone) or downloadall:
            
            # Modify coordinates
            cfg['ROI']['xll'] = C['coord'][1]
            cfg['ROI']['xll'] = C['coord'][0]
            cfg['ROI']['xll'] = C['coord'][1]
            cfg['ROI']['xll'] = C['coord'][0]
            
            # Start thread
            th = wgetthread(cfg, paths, product)
            threads.append(th)
            th.start()

# Monitor wget status
status = wgetstatus(paths)
threads.append(status)
status.start()

# Wait for all threads to finish
for th in threads:
    th.join()
