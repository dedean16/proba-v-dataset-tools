#!/usr/bin/env python3
# Extra Mathematical functions

from math import log10

from numpy import float64, square, sqrt

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

# Round x to nearest multiple of n
def roundas(x, n):
    return n * round(x/n)

# Convert x to integer if it has no trailing decimals
def maybeint(x):
    if x % 1 == 0:
        x = int(x)
    return x

# Convert rectangle from (x, y, w, h) to (xc, yc, w/2, h/2)
def rectmid(a):
    return (a[0]+a[2]/2, a[1]+a[3]/2, a[2]/2, a[3]/2)

# Check if two rectangles (x, y, w, h) overlap/collide
def rectcoll(a, b):
    ac = rectmid(a)
    bc = rectmid(b)
    xcol = abs(ac[0]-bc[0]) <= ac[2]+bc[2]
    ycol = abs(ac[1]-bc[1]) <= ac[3]+bc[3]
    return (xcol and ycol)

# Compute Root Mean Square of Errors
def RMSE(SR, HR):
    sqerr = square(float64(SR) - float64(HR))
    return sqrt(sqerr.mean())
