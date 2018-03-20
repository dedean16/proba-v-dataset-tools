#!/usr/bin/env python3
from paths import *
from map_coordlister import *
from map_writer import *
from map_genjs import *

from map_cfg import *

coordlist = coordlister(paths, mapcfg)      # List all unique ROI
mapper(coordlist, paths, mapcfg)            # Mark regions in image layers
genjs(mapcfg)                               # Generate javascript
