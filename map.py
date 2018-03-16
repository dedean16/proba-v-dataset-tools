#!/usr/bin/env python3
from paths import *
from map_coordlister import *
from map_writer import *

from map_cfg import *

coordlist = coordlister(paths, mapcfg)
mapper(coordlist, paths, mapcfg)
