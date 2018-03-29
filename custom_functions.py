#!/usr/bin/env python3
# Custom Functions
# General functions that can not be categorized as mathematical

import os

# Get total size of a folder
def get_dirsize(start_path):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size


# Print file size as rounded string in B, KB, MB, GB or TB
def sizestr(sizebytes, sep=''):
    if sizebytes < 10**3:
        return '{}{}B'.format(sizebytes, sep)
    elif sizebytes < 10**6:
        return '{}{}KB'.format(round(sizebytes/10**3), sep)
    elif sizebytes < 10**9:
        return '{}{}MB'.format(round(sizebytes/10**6), sep)
    elif sizebytes < 10**12:
        return '{}{}GB'.format(round(sizebytes/10**9), sep)
    else:
        return '{}{}TB'.format(round(sizebytes/10**12), sep)
