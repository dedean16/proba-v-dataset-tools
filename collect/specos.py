#!/usr/bin/env python3
import os
from settings import *

# Construct common paths
repopath = os.path.dirname(__file__)
datapath = os.path.realpath(repopath + datarelpath)

# Construct specific paths
if os.name == "nt":
    # Construct absolute paths from current file path
    wgetpath = os.path.realpath(repopath + wgetrelpath)
    
elif os.name == "posix":
    # Define relative paths (N.B. Relative to proba-v-data-collector.py)
    wgetpath = 'wget'                       # Points to wget executable
