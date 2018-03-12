#!/usr/bin/env python3
import os
from collect.cfg import *

# Define relative paths
# N.B. Relative to proba-v-data-collector.py
datarelpath = '/../../data'         # Points to data folder
wgetrelpath = '/../../wget/wget'    # Points to wget executable (Windows only)
# Note: As wget is usually installed by default on Linux distros, it is assumed this command is present. specos.py deals with platform specific cases such as these.

# Construct common paths
repopath = os.path.dirname(__file__)
cfg['datapath'] = os.path.realpath(repopath + datarelpath)

# Construct specific paths
if os.name == "nt":
    # Construct absolute paths from current file path
    wgetpath = os.path.realpath(repopath + wgetrelpath) # Points to wget executable in Windows
    cfg['wgetpath'] = wgetpath
    
elif os.name == "posix":
    # Define relative paths (N.B. Relative to proba-v-data-collector.py)
    wgetpath = 'wget'                       # Points to wget command in Linux
    cfg['wgetpath'] = wgetpath
