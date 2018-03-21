#!/usr/bin/env python3
# Map configuration file
# Note that this file is used both by the map tool and the couple tool

mapcfg = {}                     # Initialise map configuration

# List of products
mapcfg['products'] = [
    'L2A_-_300_m_C1',
    'L2A_-_100_m_C1',
    'S1_TOC_100_m_C1',
    'S1_TOC_-_300_m_C1',
]

# Map colors alpha channels
a = 128                         # Alpha channel (transparency)
b = 196                         # Alpha channel (transparency) of outline

# List of map colors
# Note that there should be at least as many colors products defined
mapcfg['colors'] = [
    [  0, 100, 255, a],         # Blue
    [255, 200,   0, a],         # Yellow
    [ 20, 220,  37, a],         # Green
    [255,   0,   0, a],         # Red
]


mapcfg['outlinecolor'] = (0, 0, 0, b)       # Color of marked region outline
mapcfg['ROIfilename']  = 'ROIdata.npy'      # ROI data file name
mapcfg['basemap'] = './map/img/equirectmap-bw.jpg' # Path to base layer image
