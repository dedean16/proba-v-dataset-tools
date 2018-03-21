#!/usr/bin/env python3
import numpy as np
import json

from paths import *
from map_coordlister import *
from map_writer import *
from map_genjs import *

from map_cfg import *

allROIdata, uniROIdata = coordlister(paths, mapcfg) # List all unique ROI
mapper(uniROIdata, paths, mapcfg)                   # Mark regions in layers

# Write ROI data to file
np.save(mapcfg['ROIfilename'], allROIdata)
print("Saved {} ROI entries to file '{}'.".format(len(allROIdata), mapcfg['ROIfilename']))

# Write product list as json file
with open('map/map.json', 'w') as f:
    json.dump(mapcfg['products'], f)
    print("Wrote product list as JSON file.")
