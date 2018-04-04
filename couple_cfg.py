#!/usr/bin/env python3

couplecfg = {}

couplecfg['chunksize'] = 0.762   # chunksize for images (degrees)
# couplecfg['chunksize'] = 256    # Chunksize for LR (300m) images in pixels

# Number of image tiles to extract from location
couplecfg['ntilesx'] = 3     # x direction
couplecfg['ntilesy'] = 3     # y direction

# Color channels to export
couplecfg['channels'] = ['NIR', 'RED', 'BLUE', 'SWIR']
