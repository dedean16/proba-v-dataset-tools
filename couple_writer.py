#!/usr/bin/env python3

def couple_writer(f, ind, couplecfg):
    
    # Determine level type
    try:
        f['LEVEL2A']
        level = 'LEVEL2A'
    except:
        level = 'LEVEL3'
    
    return
