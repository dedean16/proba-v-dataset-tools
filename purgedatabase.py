#!/usr/bin/env python3
# Purge corrupt HDF5 files from database

# Import h5py but suppress warning
import warnings
with warnings.catch_warnings():
    warnings.simplefilter('ignore')
    import h5py
    
import os, sys, glob
from progress.bar import ShadyBar
from paths import *


# Iterate recursively over HDF5 children and check for keys
def checkitems(f):
    if hasattr(f, 'keys'):
        for key in f.keys():
            checkitems(f[key])
        
    
# Parse optional argument '-v' for verbose output
verbose = False
if len(sys.argv) > 1:
    if sys.argv[1] == '-v':
        verbose = True

    
# Construct HDF5 database list
pattern = os.path.join(paths['data'], '**/*.[Hh][Dd][Ff]5')
filepaths = glob.glob(pattern, recursive = True)

# Initialise progress bar and error counter
print('')
bar = ShadyBar('Checking database files...', max=len(filepaths), width=25)
nerr = 0

# Iterate over all HDF5 files
for filepath in filepaths:
    
    try:
        with h5py.File(filepath, 'r') as f:
            # Recursively check all items
            checkitems(f)
        
    # Check if any file loading errors occur
    except (KeyError, RuntimeError, OSError):
        nerr += 1                   # Count file errors
        os.remove(filepath)         # Delete file!
        
        if verbose:
            print('\nCould not load file:\n' + filepath)
            print('Removing file.\n')
        
    bar.next()                      # Show progress bar

bar.finish()

# Print final result
if nerr == 0:
    print('Database is clean.')
else:
    print('Removed {} files from local database.'.format(nerr))
