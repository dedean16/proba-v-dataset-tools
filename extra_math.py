#!/usr/bin/env python3
# Extra Mathematical functions

from math import log10

# Construct a 1D linear function (y=a*x+b), based on two points
def linefunc(X1, X2, Y1, Y2):
    a = (Y2-Y1) / (X2-X1)
    b = Y1 - a*X1
    return lambda X: a*X+b

# Round x to n significant digits
def roundsignificant(x, n):
    if x == 0:
        return 0
    else:
        return round(x, -int(log10(abs(x))) + n-1)

def roundas(x, n):
    return n * round(x/n)

# Convert x to integer if it has no trailing decimals
def maybeint(x):
    if x % 1 == 0:
        x = int(x)
    return x
