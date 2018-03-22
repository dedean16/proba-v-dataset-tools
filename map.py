#!/usr/bin/env python3
import os
import numpy as np

from paths import *
from map_coordlister import *
from map_writer import *
from map_genjs import *

from map_cfg import *

allROIdata, uniROIdata = coordlister(paths, mapcfg) # List all unique ROI
genjs(mapcfg)                                       # Generate javascript
mapper(uniROIdata, paths, mapcfg)                   # Mark regions in layers

# Write ROI data to file
filename = mapcfg['ROIfilename']                    # File name
np.save(filename, allROIdata)                       # Save file
filesize = int(os.path.getsize(filename) / 1000)    # File size (KB) rounded
print("Saved {} ROI entries to file '{}' ({} KB).\n".format(len(allROIdata), filename, filesize))
