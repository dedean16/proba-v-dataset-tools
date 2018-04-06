#!/usr/bin/env python3
from PIL import Image, ImageDraw
from extra_math import linefunc

# Mark regions in layers and write to image files
def mapper(uniROIdata, paths, mapcfg, coords):
    
    # Read resolution from basemap image
    imsize = Image.open(mapcfg['basemap']).size
    print("\nUsing basemap resolution: {}x{}.".format(*imsize))
    
    # Initialise image layers
    npr  = len(mapcfg['products'])
    imgs = [Image.new('RGBA', imsize) for i in range(npr)]
    
    # Construct linear earth to pixel coordinate mapper
    maplon = linefunc(-180, 180, 0, imsize[0]-1)
    maplat = linefunc( -90,  90, imsize[1]-1, 0)
    
    for ROI in uniROIdata:
        
        # Unpack ROI info
        coord = ROI['coord']
        iprod = ROI['iprod']
        
        # Convert earth coordinates to map coordinates
        x1 = int(maplon(coord[0]))
        x2 = int(maplon(coord[1]))
        y1 = int(maplat(coord[2]))
        y2 = int(maplat(coord[3]))
        
        # Retrieve colors of product
        r,g,b,a = mapcfg['colors'][iprod]
        
        # Draw rectangle
        ImageDraw.Draw(imgs[iprod]).rectangle(\
                        (x1, y1, x2, y2),\
                        fill = (r, g, b, a),\
                        outline = mapcfg['outlinecolor'])
        
        # Note:
        # Currently, each rectangle draw replaces the previous one,
        # instead of blending according to the alpha channels.
        # In future versions this might need to be fixed.
        
    # Write image files to disk
    for i in range(npr):
        img = imgs[i]
        img.save('map/img/maplayer{}.png'.format(i), 'PNG')
        
    print("Done marking {} regions on {} layers.".format(len(uniROIdata), npr))
    
    
    #======================================================#
    #========= Mark input coords as points on map =========#
    
    markerimg = Image.new('RGBA', imsize)       # Initialise input coords image
    r = mapcfg['markerradius']                  # Fetch marker radius
    
    for coord in coords:                        # Iterate over input coords
        x = int(maplon(coord[1]))
        y = int(maplat(coord[0]))
        
        # Draw marker circle
        ImageDraw.Draw(markerimg).ellipse(\
                        (x-r, y-r, x+r, y+r),\
                        fill = mapcfg['markercolor'],\
                        outline = mapcfg['markeroutlinecolor'])
    
    # Save input coords marker image
    markerimg.save('map/img/markerlayer.png', 'PNG')
    
    print("Done marking {} coordinates on input coordinate layer.".format(len(coords)))
    
    return
