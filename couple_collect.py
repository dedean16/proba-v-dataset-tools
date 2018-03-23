#!/usr/bin/env python3

import sys

from paths import *
from map_cfg import *
from couple_coords import *
from couple_filepaths import *
from collect_cfg import *
from collect_credentials import *
from collect_wgetthread import *

CC = couplepaths(coords, mapcfg)

# Parse optional argument 'all' for downloading all
downloadall = False
if len(sys.argv) > 1:
    if sys.argv[1] == 'all':
        downloadall = True
    
# Initialise thread collection
threads = []

# Start wget threads
for C in CC:
    for product in cfg['products']:
        if (len(C['filepaths']) == 0) or downloadall:
            
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
