#!/usr/bin/env python3
from PIL import Image, ImageDraw
from scipy.interpolate import interp1d

def mapper(ROIdata, paths, mapcfg):
    
    # Initialise image
    img = Image.new('RGBA',(1024, 512))    ### generalize!
    draw = ImageDraw.Draw(img)
    
    #### generalize numbers!
    maplon = interp1d([-180,180],[0,1023])
    maplat = interp1d([-90,90],[511,0])
    
    for ROI in ROIdata:
        
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
        draw.rectangle((x1, y1, x2, y2), fill=(r, g, b, a))
        
    img.save('map/img/maplayer1.png', 'PNG')
        
    return
