#!/usr/bin/env python3
from paths import *
from map_coordlister import *
from map_writer import *

from map_cfg import *

mapper(coordlister(paths, mapcfg), paths, mapcfg)
