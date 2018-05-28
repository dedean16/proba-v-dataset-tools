#!/usr/bin/env python3
"""
Create earth map of database contents.

Writes layer images to /map/img folder. Location of map file: /map/map.html.
"""

from os.path import getsize
import numpy as np

from custom_functions import sizestr
from paths import paths
from map_coordlister import coordlister
from map_writer import mapper
from map_genjs import genjs
from map_cfg import mapcfg
from couple_coords import coords


print('\n=== MAP ===')

allROIdata, uniROIdata = coordlister(paths, mapcfg)  # List all unique ROI
genjs(mapcfg)                                        # Generate javascript
mapper(uniROIdata, paths, mapcfg, coords)            # Mark regions in layers

# Write ROI data to file
filename = mapcfg['ROIfilename']                     # File name
np.save(filename, allROIdata)                        # Save file
filesize = sizestr(getsize(filename), sep=' ')       # File size (KB) rounded
print("Saved {} ROI entries to file '{}' ({}).\n"
      .format(len(allROIdata), filename, filesize))
