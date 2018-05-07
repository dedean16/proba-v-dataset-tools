from zipfile import *
from math import sqrt
from libtiff import TIFF

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
    with ZipFile(file, 'r') as zipf:
        pass
