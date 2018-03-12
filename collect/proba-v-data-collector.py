#!/usr/bin/env python3
from settings import *
from credentials import *
from wgetthread import *

# Initialise thread collection
threads = []

# Start wget threads
for product in settings['products']:
    th = wgetthread(settings, product)
    threads.append(th)
    th.start()

# Wait for all threads to finish
for th in threads:
    th.join()
