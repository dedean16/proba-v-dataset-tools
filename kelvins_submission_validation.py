#!/usr/bin/env python3
"""
Kelvins Submission Validation script.

Contains functions for evaluating submissions on the Kelvins website.
score -- Compute total Kelvins score from zipfile submission.
validate -- Validate submitted zipfile.
"""

from os.path import split, join
from zipfile import ZipFile

import png
import numpy as np


# === PNG READER STUFF === #
type2depth = {      # Dictionary for datatype (str) to bitdepth
    'bool': 1,
    'uint8': 8,
    'uint16': 16,
}


depth2type = {      # Dictionary for bitdepth to datatype (str)
    1: 'bool',
    8: 'uint8',
    16: 'uint16',
}


# Read greyscale PNG image
def readgreypng(path):
    """Read greyscale PNG to numpy array. Accepts 1-, 8- and 16-bit."""
    # Read data, determine bitdepth and datatype
    pngdata = png.Reader(path).read()               # Read PNG data
    bitdepth = pngdata[3]['bitdepth']               # Get bitdepth
    dataclass = getattr(np, depth2type[bitdepth])   # Get dataclass

    if not pngdata[3]['greyscale']:
        raise ValueError('Not a greyscale image.')

    # Check for valid bitdepth
    if bitdepth not in depth2type:
        raise ValueError('Accepted bit depths: {}. Given: {}'.format(
                            list(depth2type.keys()), bitdepth))

    array = np.array(list(pngdata[2]), dtype=dataclass)  # Load as numpy array
    return array


def RMSE(SR, HR, SM):
    """Compute Root Mean Square of Errors."""
    sqerr = np.square(np.float64(SR) - np.float64(HR))
    return np.sqrt(sqerr[SM].mean())


# === Parameters === #
shape = (384, 384)
dtype = 'uint16'
N = 39

suffix = ''
SRprefix = 'SR'
HRprefix = 'HR'
SMprefix = 'SM'
normprefix = 'norm'
ext = '.png'
normext = '.txt'

validatezipname = 'validate.zip'


# === Constructed values === #
dirpath, filename = split(__file__)
# HRpath = dirpath.replace('/uploads/competitions/',
#                          '/uploads/media/competitions/') + '/'
validatezip = join(dirpath.replace('/uploads/competitions/',
                         '/uploads/media/competitions/'), validatezipname)


# === Functions === #

def fnamelist(path, prefix, N, suffix, ext):
    """Create list of filenames, required for Kelvins submission. (Max: 99)."""
    fnamer = lambda x: '{}{}set{:03}{}{}'.format(path, prefix, x, suffix, ext)
    return list(map(fnamer, range(1, N+1)))


def scoreterm(SR, HR, SM, norm):
    """
    Compute single score term, based on 1 SR and 1 HR image.

    SR -- The Super Resolution resolved image.
    HR -- The 'ground truth' High Resolution image.
    SM -- Score Mask. Indicates which pixels will be used in scoring.
    norm -- Normalization factor for the Root Mean Square Error.
    """
    return np.exp(-RMSE(SR, HR, SM) / norm)


# This return the score for the leaderboard
# if there is an error an exception must be thrown here, but will not be
# visible to the user. Instead the submission will be marked invalid and a
# generic error communicated to the user via the web page. May return a single
# score or a 2 element tuple. In which case the first element is the score and
# the second the extra_info on the leaderboard
def score(file):
    u"""
    Compute total Kelvins score from zipfile submission.

    totscore = 1/N ∑ exp[ −RMSE(SRᵢ) / ⟨RMSE(bicubic)⟩ᵢ ]
    """
    singlescores = [0]*N

    # Open file as ZipFile
    with ZipFile(file, 'r') as zf, ZipFile(validatezip, 'r') as vzf:

        fHRs = fnamelist('', HRprefix, N, suffix, ext)
        fSRs = fnamelist('', SRprefix, N, suffix, ext)
        fnorms = fnamelist('', normprefix, N, suffix, normext)
        fSMs = fnamelist('', SMprefix, N, suffix, ext)

        for i in range(N):                  # Iterate over images
            # Open normalization file,  HR image and SR image
            with vzf.open(fHRs[i]) as fHR,\
                 vzf.open(fnorms[i]) as fnorm,\
                 vzf.open(fSMs[i]) as fSM,\
                 zf.open(fSRs[i]) as fSR:

                HRimg = readgreypng(fHR)
                SRimg = readgreypng(fSR)
                SMask = readgreypng(fSM)
                norm = float(fnorm.read())

                # Calculate scoresum term
                # norm = 100
                singlescores[i] = scoreterm(HRimg, SRimg, SMask, norm)

    totscore = np.mean(singlescores)        # Compute total score (mean)

    return totscore, 'extra_info'


# This runs immmediately after the upload and validates the easy bits (format
# size etc.) if succesfull (no exception) score will be run later (by celery)
# otherwise the text of the exception is shown on the web site (the user sees
# it) TEST IT PROPERLY
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
        imgnames = fnamelist('', SRprefix, N, suffix, ext)
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


    score(file)  ### should be removed
