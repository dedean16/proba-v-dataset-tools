import os
from zipfile import *
import numpy as np
from scipy.misc import imread

#=== Parameters ===#
shape = (768, 768)
dtype = 'uint16'

N = 3
prefix = 'imgset'
SRsuffix = 'SR.png'
HRsuffix = 'HR.png'


#=== Constructed values ===#
dirpath, filename = os.path.split(__file__)
HRpath = dirpath.replace('/uploads/competitions/', '/uploads/media/competitions/') + '/'


#=== Functions ===#

# Generate list of numbered file names (starting with 1, max 99)
def fnamelist(path, prefix, N, suffix):
    return list(map(lambda x: '{}{}{:02}{}'.format(path, prefix, x, suffix), range(1, N+1)))


# Compute Root Mean Square of Errors
def RMSE(SR, HR):
    diff = np.float64(SR) - np.float64(HR)
    return np.sqrt( np.square(diff).mean() )

# Compute score term
def scoreterm(SR, HR):
    return np.exp( -RMSE(SR, HR) / 100 )  ### the 100 needs to be replaced by the average RMSE of bicubic

# This return the score for the leaderboard
# if there is an error an exception must be thrown here, but will not be visible to the user. Instead
# the submission will be marked invalid and a generic error communicated to the user via the web page.
# May return a single score or a 2 element tuple. In
# which case the first element is the score and the second the extra_info on the leaderboard
def score(file):
    
    singlescores = [0]*N
    
    # Open file as ZipFile
    with ZipFile(file, 'r') as zf:
        
        HRimgpaths = fnamelist(HRpath, prefix, N, HRsuffix)
        SRimgnames = fnamelist('',     prefix, N, SRsuffix)
        
        for i in range(N):      # Iterate over images
            
            # Open HR image and SR image
            with open(HRimgpaths[i], 'rb') as HRf, zf.open(SRimgnames[i]) as SRf:
                HRimg = imread(HRf)
                SRimg = imread(SRf)
                
                # Calculate scoresum term
                singlescores[i] = scoreterm(HRimg, SRimg)
                
    totscore = np.mean( singlescores )
    
    return totscore, 'extra_info'


# This runs immmediately after the upload and validates the easy bits (format size etc.)
# if succesfull (no exception) score will be run later (by celery)
# otherwise the text of the exception is shown on the web site (the user sees it) TEST IT PROPERLY
def validate(file):
    
    # Open file as ZipFile
    with ZipFile(file, 'r') as zf:
        
        # Check zip file corruption
        ziptest = zf.testzip()
        if ziptest != None:
            raise ValueError('Corrupt file or header: ' + ziptest)
        
        # Build list of required files. Check against namelist. Throw error if files are missing.
        contents = zf.namelist()
        imgnames = fnamelist('', prefix, N, SRsuffix)
        imgnamesmissing = list(filter(lambda x: not(x in contents), imgnames))
        
        if len(imgnamesmissing) > 0:
            raise ValueError('Files missing: ' + str(imgnamesmissing))
        
        # Open all content files as images
        for SRfname in contents:
            with zf.open(SRfname) as SRf:
                img = imread(SRf)

                # Check datatype
                if img.dtype != dtype:
                    raise ValueError('Wrong datatype: {}. Required datatype: {}'.format(img.dtype, dtype))
                    
                # Check resolution
                if img.shape != shape:
                    raise ValueError('Wrong resolution: {}. Required resolution: {}'.format(img.shape, shape))
