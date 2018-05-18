#!/usr/bin/env python3
"""Run the Kelvins validation and score functions locally, for testing."""
# Script to test the script kelvins_submission_validation

from kelvins_submission_validation import validate, score

zippath = 'submission-test.zip'

# Open the 'submission' zip file and run validate() and score()
with open(zippath, 'rb') as file:
    print('Validation')
    print(validate(file))

    print('\nScore')
    print(score(file))
