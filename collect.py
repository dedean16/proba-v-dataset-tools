#!/usr/bin/env python3
"""Collect HDF5 files from the PROBA-V products host server."""

from paths import paths
from collect_credentials import cfg
from collect_wgetthread import wgetthread, wgetstatus


print('\n=== COLLECT ===')

# Initialise thread collection
threads = []

# Start wget threads
for product in cfg['products']:
    th = wgetthread(cfg, paths, product)
    threads.append(th)
    th.start()

# Monitor wget status
status = wgetstatus(paths)
threads.append(status)
status.start()

# Wait for all threads to finish
for th in threads:
    th.join()
