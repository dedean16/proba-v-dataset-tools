#!/usr/bin/env python3
# Map configuration

mapcfg={}               # Initialise map configuration

mapcfg['products'] = ['S1_TOC_100_m_C1', 'S1_TOC_-_300_m_C1',\
                      'L2A_-_300_m_C1', 'L2A_-_100_m_C1']

# Define map colors RGBA
a =  96                 # Alpha channel (transparency)
b = 196                 # Alpha channel (transparency) of outline

mapcfg['colors'] = [[  0,   0, 192, a],\
                    [  0, 128, 128, a],\
                    [128,  64,   0, a],\
                    [128,   0,  64, a]]

mapcfg['outlinecolor'] = (0, 0, 0, b)

mapcfg['basemap'] = './map/img/equirectmap-bw.jpg'
