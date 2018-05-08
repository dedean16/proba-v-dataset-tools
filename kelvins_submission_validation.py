from zipfile import *
from math import sqrt
from scipy.misc import imread

N = 3
dtype = 'uint16'
shape = (768, 768)


def RMSE(SR, HR):
    return sqrt(2)

# This return the score for the leaderboard
# if there is an error an exception must be thrown here, but will not be visible to the user. Instead
# the submission will be marked invalid and a generic error communicated to the user via the web page.
# May return a single score or a 2 element tuple. In
# which case the first element is the score and the second the extra_info on the leaderboard
def score(file):
    
    # SR = TIFF.open(tiffiles[0], mode='r').read_image()
    
    return 0.02, 'extra_info'


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
        imgnamelist = map(lambda x: 'imgset{:02}SR.tif'.format(x), range(1, N+1))
        imgnamesmissing = list(filter(lambda x: not(x in contents), imgnamelist))
        
        if len(imgnamesmissing) > 0:
            raise ValueError('Files missing: ' + str(imgnamesmissing))
        
        # Open all content files as images
        for cfname in contents:
            with zf.open(cfname) as cf:
                img = imread(cf)

                # Check datatype
                if img.dtype != dtype:
                    raise ValueError('Wrong datatype: {}. Required datatype: {}'.format(img.dtype, dtype))
                    
                # Check resolution
                if img.shape != shape:
                    raise ValueError('Wrong resolution: {}. Required resolution: {}'.format(img.shape, shape))
