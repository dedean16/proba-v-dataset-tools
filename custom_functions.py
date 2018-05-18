#!/usr/bin/env python3
"""
General functions that can not be categorized as mathematical.

get_dirsize --
sizestr --
ensure_folders_if --
"""

import os
from extra_math import roundsignificant, maybeint


def get_dirsize(start_path):
    """Get folder size in bytes from a path string. Sums subdir contents."""
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size


# Print file size as rounded string in B, KB, MB, GB or TB
def sizestr(sizebytes, sep='', signif=3):
    """
    Return string representation of size in bytes, with appropriate prefix.

    sizebytes -- Integer size in bytes.
    sep -- Seperation character between number and unit. Default ''
    signif -- Number of significant digits. Default 3.
    """
    # Round size to 3 significant digits
    roundbytes = roundsignificant(sizebytes, signif)

    if abs(sizebytes) < 10**3:
        return '{}{}B'.format(roundbytes, sep)
    elif abs(sizebytes) < 10**6:
        return '{}{}KB'.format(maybeint(roundbytes/10**3), sep)
    elif abs(sizebytes) < 10**9:
        return '{}{}MB'.format(maybeint(roundbytes/10**6), sep)
    elif abs(sizebytes) < 10**12:
        return '{}{}GB'.format(maybeint(roundbytes/10**9), sep)
    else:
        return '{}{}TB'.format(maybeint(roundbytes/10**12), sep)


# Create folders if required and if conditions are True
def ensure_folders_if(path, condition=True):
    """Make directory if it doesn't exist yet and condition is True."""
    if not os.path.exists(path) and condition:
        os.makedirs(path)
