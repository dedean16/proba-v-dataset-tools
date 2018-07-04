#!/usr/bin/env python3
"""
Holds locations of dedicated folder paths.

Contains location of: data folder, wget executable, tiles folder,
kelvinspath folder, srresults folder.
wget can be specified per platform.
"""
from os import path, name

# Initialise paths dictionary
paths = {}

# Define relative paths
# N.B. Relative to main repo directory
datarelpath = '/../data'        # Points to data folder
wgetrelpath = '/../wget/wget'   # Points to wget executable (Windows only)
tilespath = '/tiles'            # Points to tiles folder
kelvinspath = '/kelvinsset'     # points to kelvinsset folder
srresults = '/sr/results'       # Points to SR results folder

# Note: If Linux is used, wget should be in the PATH.

# ============================================================= #
# Construct common paths
repopath = path.dirname(__file__)
paths['data'] = path.realpath(repopath + datarelpath)
paths['tiles'] = path.realpath(repopath + tilespath)
paths['kelvinsset'] = path.realpath(repopath + kelvinspath)
paths['srresults'] = path.realpath(repopath + srresults)

# Construct specific paths
if name == "nt":
    # Construct absolute paths from current file path
    wgetpath = path.realpath(repopath + wgetrelpath)  # wget exe in Windows
    paths['wget'] = wgetpath

elif name == "posix":
    # Define relative paths (N.B. Relative to main repo directory)
    wgetpath = 'wget'                       # Points to wget command in Linux
    paths['wget'] = wgetpath
