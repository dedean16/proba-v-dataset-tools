#!/usr/bin/env python3

from paths import *
from collect_cfg import *
from collect_credentials import *
from collect_wgetthread import *

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
