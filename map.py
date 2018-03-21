#!/usr/bin/env python3
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
np.save(mapcfg['ROIfilename'], allROIdata)
print("Saved {} ROI entries to file '{}'.".format(len(allROIdata), mapcfg['ROIfilename']))
