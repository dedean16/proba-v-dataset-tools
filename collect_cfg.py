#!/usr/bin/env python3

# Initialise cfg dictionary
cfg = {}

# Define date of interest
cfg['year']    = 2017              # Year of interest
cfg['month']   = 8                 # Month of interest

# Define Region of Interest Coordinates
ROI = {}
ROI['xll']     = 103               # X Lower Left
ROI['yll']     =   1               # Y Lower Left
ROI['xur']     = 104               # X Upper Right
ROI['yur']     =   2               # Y Upper Right
cfg['ROI']     = ROI

# Product URLs
cfg['baseurl']  = 'http://www.vito-eodata.be/PDF/datapool/Free_Data/'

#=============================================#
# Set list of products - choose one or define your own
# Level 3 - S1
# cfg['products'] = ['PROBA-V_100m/S1_TOC_100_m_C1/', 'PROBA-V_300m/S1_TOC_-_300_m_C1/']
#
# Level 2A
# cfg['products'] = ['PROBA-V_300m/L2A_-_300_m_C1/', 'PROBA-V_100m/L2A_-_100_m_C1/']
#
# Level 3 and Level 2A
cfg['products'] = ['PROBA-V_300m/L2A_-_300_m_C1/', 'PROBA-V_100m/L2A_-_100_m_C1/', 'PROBA-V_100m/S1_TOC_100_m_C1/', 'PROBA-V_300m/S1_TOC_-_300_m_C1/']

# Since the corner coordinates can't be the same, this is added in the case of single points
cfg['pointROIoffset'] = 1
