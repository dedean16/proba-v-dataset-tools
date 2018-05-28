#!/usr/bin/env python3
"""Configuration of builddataset."""

buildcfg = {}

# === Selection requirements === #
# Minimum clear pixel coverage in the constructed Source Mask
# Note: Due to water vapour, most rivers and lakes will be marked as not clear
buildcfg['min_clearance'] = 0.75

# Minimum number of LR images per set
# Note: SR requires at the very minimum n^2 LR images, where n is scale factor
buildcfg['nmin'] = 12


# === File names === #
buildcfg['normfilename'] = 'norm.txt'   # Name of the file containing the norm
buildcfg['sources'] = 'sources.txt'     # File name of list of source files
