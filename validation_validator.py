#!/usr/bin/env python3
# Script to test the script kelvins_submission_validation

from zipfile import ZipFile
from kelvins_submission_validation import *

zippath = 'submission-test.zip'

# Open the 'submission' zip file and run validate() and score()
with open(zippath, 'rb') as file:
    print('Validation')
    print(validate(file))
    
    print('\nScore')
    print(score(file))
