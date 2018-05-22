#!/usr/bin/env python3
"""Configuration of Couple parameters."""

couplecfg = {}

couplecfg['chunksizeLR'] = 256      # Chunksize for LR (300m) images in pixels
couplecfg['scaleHR'] = 3            # Scale of HR/LR

# Number of image tiles to extract from location
couplecfg['ntilesx'] = 3            # x direction
couplecfg['ntilesy'] = 3            # y direction

# Color channels to export
couplecfg['channels'] = ['NIR', 'RED', 'BLUE', 'SWIR']
couplecfg['qualitychannel'] = '/QUALITY/SM'
couplecfg['qmaskname'] = 'QMASK'

# Subfolder names and writing flags
couplecfg['norm'] = True            # Write normalized image
couplecfg['orig'] = True            # Write original image
couplecfg['normdir'] = '/norm'      # Subfolder name for normalized images
couplecfg['origdir'] = '/orig'      # Subfolder name for original images

# Minimum fraction of clear pixels (no clouds, ice, etc...)
couplecfg['min_clearance'] = 0.8


# === Checks === #
if couplecfg['chunksizeLR'] % 2 != 0 \
            or couplecfg['chunksizeLR'] <= 0 \
            or type(couplecfg['chunksizeLR']) != int:
    raise ValueError('couple_cfg: chunksizeLR must be positive even integer.')
