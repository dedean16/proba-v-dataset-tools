#!/usr/bin/env python3
from cfg import *
from credentials import *
from wgetthread import *

# Initialise thread collection
threads = []

# Start wget threads
for product in cfg['products']:
    th = wgetthread(cfg, product)
    threads.append(th)
    th.start()

# Wait for all threads to finish
for th in threads:
    th.join()
