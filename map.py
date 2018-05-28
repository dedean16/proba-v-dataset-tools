#!/usr/bin/env python3
"""
Create earth map of database contents.

Writes layer images to /map/img folder. Location of map file: /map/map.html.
"""

import os
import numpy as np

from custom_functions import *
from paths import *
from map_coordlister import *
from map_writer import *
from map_genjs import *
from map_cfg import *
from couple_coords import *

allROIdata, uniROIdata = coordlister(paths, mapcfg) # List all unique ROI
genjs(mapcfg)                                       # Generate javascript
mapper(uniROIdata, paths, mapcfg, coords)           # Mark regions in layers

# Write ROI data to file
filename = mapcfg['ROIfilename']                    # File name
np.save(filename, allROIdata)                       # Save file
filesize = sizestr(os.path.getsize(filename), sep=' ')    # File size (KB) rounded
print("Saved {} ROI entries to file '{}' ({}).\n".format(len(allROIdata), filename, filesize))
