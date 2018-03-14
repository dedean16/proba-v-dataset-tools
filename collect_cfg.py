#!/usr/bin/env python3

# Initialise cfg dictionary
cfg = {}

# Define date of interest
cfg['year']    = 2017              # Year of interest
cfg['month']   = 8                 # Month of interest

# Define Region of Interest Coordinates
ROI = {}
ROI['xll']     = -97.75            # X Lower Left
ROI['yll']     =  41.93            # Y Lower Left
ROI['xur']     = -97.32            # X Upper Right
ROI['yur']     =  42.19            # Y Upper Right
cfg['ROI']     = ROI

# Product URLs
cfg['baseurl']  = 'http://www.vito-eodata.be/PDF/datapool/Free_Data/'
cfg['products'] = ['PROBA-V_100m/S1_TOC_100_m_C1/', 'PROBA-V_300m/S1_TOC_-_300_m_C1/']
