#!/usr/bin/env python3
"""
Kelvins Submission Validation script.

Contains functions for evaluating submissions on the Kelvins website.
score -- Compute total Kelvins score from zipfile submission.
validate -- Validate submitted zipfile.
"""

import os
from zipfile import ZipFile

import numpy as np

from extra_math import RMSE
from pngtools import readgreypng

# === Parameters === #
shape = (768, 768)
dtype = 'uint16'

N = 3
prefix = 'imgset'
SRsuffix = 'SR.png'
HRsuffix = 'HR.png'


# === Constructed values === #
dirpath, filename = os.path.split(__file__)
HRpath = dirpath.replace('/uploads/competitions/',
                         '/uploads/media/competitions/') + '/'


# === Functions === #

def fnamelist(path, prefix, N, suffix):
    """Create list of filenames, required for Kelvins submission. (Max: 99)."""
    fnamefunc = lambda x: '{}{}{:02}{}'.format(path, prefix, x, suffix)
    return list(map(fnamefunc, range(1, N+1)))


def scoreterm(SR, HR):
    """Compute single score term, based on 1 SR and 1 HR image."""
    ### the 100 needs to be replaced by the average RMSE of bicubic
    return np.exp(-RMSE(SR, HR) / 100)


# This return the score for the leaderboard
# if there is an error an exception must be thrown here, but will not be visible to the user. Instead
# the submission will be marked invalid and a generic error communicated to the user via the web page.
# May return a single score or a 2 element tuple. In
# which case the first element is the score and the second the extra_info on the leaderboard
def score(file):
    u"""
    Compute total Kelvins score from zipfile submission.

    totscore = 1/N ∑ exp[ −RMSE(SRᵢ) / ⟨RMSE(bicubic)⟩ᵢ ]
    """
    singlescores = [0]*N

    # Open file as ZipFile
    with ZipFile(file, 'r') as zf:

        HRfpaths = fnamelist(HRpath, prefix, N, HRsuffix)
        SRfnames = fnamelist('',     prefix, N, SRsuffix)

        for i in range(N):                  # Iterate over images
            # Open HR image and SR image
            with open(HRfpaths[i], 'rb') as HRf, zf.open(SRfnames[i]) as SRf:
                HRimg = readgreypng(HRf)
                SRimg = readgreypng(SRf)

                # Calculate scoresum term
                singlescores[i] = scoreterm(HRimg, SRimg)

    totscore = np.mean(singlescores)        # Compute total score (mean)

    return totscore, 'extra_info'


# This runs immmediately after the upload and validates the easy bits (format size etc.)
# if succesfull (no exception) score will be run later (by celery)
# otherwise the text of the exception is shown on the web site (the user sees it) TEST IT PROPERLY
def validate(file):
    """
    Validate submitted zipfile.

    Check for corruption, missing files, datatype and resolution of images.
    """
    # Open file as ZipFile
    with ZipFile(file, 'r') as zf:

        # Check zip file corruption
        ziptest = zf.testzip()
        if ziptest is not None:
            raise ValueError('Corrupt file or header: ' + ziptest)

        # Build list of required files. Build list of missing files.
        contents = zf.namelist()
        imgnames = fnamelist('', prefix, N, SRsuffix)
        imgnamesmissing = list(filter(lambda x: not(x in contents), imgnames))

        # Throw error if files are missing.
        if len(imgnamesmissing) > 0:
            raise ValueError('Files missing: ' + str(imgnamesmissing))

        # Open all content files as images
        for SRfname in contents:
            with zf.open(SRfname) as SRf:
                img = readgreypng(SRf)

                # Check datatype
                if img.dtype != dtype:
                    raise ValueError('Wrong datatype {} in file {}. \
                                     Required datatype: {}'
                                     .format(img.dtype, SRfname, dtype))

                # Check resolution
                if img.shape != shape:
                    raise ValueError('Wrong resolution {} in file {}. \
                                     Required resolution: {}'
                                     .format(img.shape, SRfname, shape))

