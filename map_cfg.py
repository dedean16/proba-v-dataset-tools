#!/usr/bin/env python3

mapcfg={}               # Initialise map configuration

mapcfg['products'] = ['PROBA-V_100m/S1_TOC_100_m_C1/',\
                      'PROBA-V_300m/S1_TOC_-_300_m_C1/',\
                      'PROBA-V_300m/L2A_-_300_m_C1/',\
                      'PROBA-V_100m/L2A_-_100_m_C1/']

# Define map colors RGBA
a = 128                 # Alpha channel (transparency)
b = 196                 # Alpha channel (transparency) of outline

mapcfg['colors'] = [[  0,   0, 192, a],\
                    [  0, 128, 128, a],\
                    [128,  64,   0, a],\
                    [128,   0,  64, a]]

mapcfg['outlinecolor'] = (0, 0, 0, b)

mapcfg['basemap'] = './map/img/equirectmap-bw.jpg'
