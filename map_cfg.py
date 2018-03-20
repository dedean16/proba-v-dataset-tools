#!/usr/bin/env python3
# Map configuration

mapcfg={}               # Initialise map configuration

mapcfg['products'] = ['L2A_-_300_m_C1', 'L2A_-_100_m_C1',\
                      'S1_TOC_100_m_C1', 'S1_TOC_-_300_m_C1',]

# Define map colors RGBA
a = 128                 # Alpha channel (transparency)
b = 196                 # Alpha channel (transparency) of outline

mapcfg['colors'] = [[  0, 100, 255, a],\
                    [255, 200,   0, a],\
                    [ 20, 220,  37, a],\
                    [255,   0,   0, a]]

mapcfg['outlinecolor'] = (0, 0, 0, b)

mapcfg['basemap'] = './map/img/equirectmap-bw.jpg'
