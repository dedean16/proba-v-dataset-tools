#!/usr/bin/env python3

# Initialise settings dictionary
settings = {}

# Define date of interest
settings['year']    = 2017              # Year of interest
settings['month']   = 8                 # Month of interest

# Define Region of Interest Coordinates
ROI = {}
ROI['xll']          = 44.8              # X Lower Left
ROI['yll']          = 19.7              # Y Lower Left
ROI['xur']          = 45.2              # X Upper Right
ROI['yur']          = 20.0              # Y Upper Right
settings['ROI']     = ROI

# Define relative paths
# N.B. Relative to proba-v-data-collector.py
settings['datarelpath'] = '/../../data'         # Points to data folder
settings['wgetrelpath'] = '/../../wget/wget'    # Points to wget executable (Windows only)
# Note: As wget is usually installed by default on Linux distros, it is assumed this command is present. specos.py deals with platform specific cases such as these.

# Product URLs
settings['baseurl']  = 'http://www.vito-eodata.be/PDF/datapool/Free_Data/'
settings['products'] = ['PROBA-V_100m/S1_TOC_100_m_C1/', 'PROBA-V_300m/S1_TOC_-_300_m_C1/']
