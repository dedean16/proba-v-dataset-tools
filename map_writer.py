#!/usr/bin/env python3
from PIL import Image, ImageDraw
from scipy.interpolate import interp1d

def mapper(coordlist, paths):
    
    img = Image.new('RGBA',(1024, 512))    ### generalize!
    draw = ImageDraw.Draw(img)
    
    #### generalize!
    maplon = interp1d([-180,180],[0,1023])
    maplat = interp1d([-90,90],[511,0])
    
    for coord in coordlist:
        
        # Convert earth coordinates to map coordinates
        x1 = int(maplon(coord[0]))
        x2 = int(maplon(coord[1]))
        y1 = int(maplat(coord[2]))
        y2 = int(maplat(coord[3]))
        
        # Draw rectangle
        draw.rectangle((x1, y1, x2, y2), fill=(0, 0, 255, 75))
        
    img.save('testmap.png', 'PNG')
        
    return
    
    
    
