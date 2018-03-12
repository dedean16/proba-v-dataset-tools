#!/usr/bin/env python3

# Check if the file is loaded as a submodule, by trying to import paths
try:
    from paths import *
except:
    print("\nThis tools package is setup as a structure of submodules. Therefore, you should run this script in the following manner: 'python3 -m collect.collect'\n")
    raise

from collect.cfg import *
from collect.credentials import *
from collect.wgetthread import *

# Initialise thread collection
threads = []

# Start wget threads
for product in cfg['products']:
    th = wgetthread(cfg, paths, product)
    threads.append(th)
    th.start()

# Wait for all threads to finish
for th in threads:
    th.join()
