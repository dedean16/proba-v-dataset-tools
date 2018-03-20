#!/usr/bin/env python3
# Generate javascript for product list

def genjs(mapcfg):
    with open('map/map.js', 'w') as f:
        
        js = ''
        
        # Generate code for product list
        js += 'var products = ' + str(mapcfg['products']) + ';'
        
        # Write javascript to file
        f.write(js)
        
    print('Generated javascript map code.')
