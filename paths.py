#!/usr/bin/env python3
import os

# Initialise paths dictionary
paths = {}

# Define relative paths
# N.B. Relative to proba-v-data-collector.py
datarelpath = '/../data'        # Points to data folder
wgetrelpath = '/../wget/wget'   # Points to wget executable (Windows only)
tilespath   = '/tiles'          # Points to tiles folder
srresults   = '/sr/results'     # Points to SR results folder
# Note: As wget is usually installed by default on Linux distros, it is assumed this command is present. paths.py deals with platform specific cases such as these.

#=============================================================#
# Construct common paths
repopath = os.path.dirname(__file__)
paths['data'] = os.path.realpath(repopath + datarelpath)
paths['tiles'] = os.path.realpath(repopath + tilespath)
paths['srresults'] = os.path.realpath(repopath + srresults)

# Construct specific paths
if os.name == "nt":
    # Construct absolute paths from current file path
    wgetpath = os.path.realpath(repopath + wgetrelpath) # Points to wget executable in Windows
    paths['wget'] = wgetpath
    
elif os.name == "posix":
    # Define relative paths (N.B. Relative to proba-v-data-collector.py)
    wgetpath = 'wget'                       # Points to wget command in Linux
    paths['wget'] = wgetpath
