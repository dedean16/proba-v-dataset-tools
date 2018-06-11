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


# === File and Folder names === #
buildcfg['normfilename'] = 'norm'     # Name of the file containing the norm
buildcfg['HRname'] = 'HR'             # Name of HR files
buildcfg['scoremaskname'] = 'SM'      # Name of the score mask file
buildcfg['sources'] = 'sources.txt'   # File name of list of source files
buildcfg['dirvalidate'] = 'validate'  # Folder name of validation HRs
buildcfg['dirsubtest'] = 'submission-test'  # Name of submission test folder
buildcfg['SRname'] = 'SR'             # Name of SR submission-test files
buildcfg['subtestnoise'] = 25         # standard dev of noise of sub test
