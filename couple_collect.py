#!/usr/bin/env python3
"""Run HDF5 collection threads on remaining files."""

import sys
import glob
from os.path import join, split

from paths import paths
from couple_coords import coords
from collect_credentials import cfg
from collect_wgetthread import wgetstatus, wgetthread


print('\n=== COUPLE COLLECT ===')

# Construct list of processed PNG files (full paths)
pattern = join(paths['tiles'], '**/*.png')
filepaths = glob.glob(pattern, recursive=True)

# Construct set of unique HDF5 filenames and concatenate to single string
fileset = set(map(lambda x: ',*' + split(x)[1][:-4] + '.HDF5', filepaths))
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
        cfg['ROI']['xur'] = c[1] + cfg['pointROIoffset']
        cfg['ROI']['yur'] = c[0] + cfg['pointROIoffset']

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
