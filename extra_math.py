#!/usr/bin/env python3
"""
Extra Mathematical functions.

linefunc            -- Construct 1D linear function.
roundsignificant    -- Round x to n significant digits.
roundas             -- Round x to nearest multiple of n.
maybeint            -- Convert x to int if it has no trailing decimals.
rectmid             -- Convert rectangle from (x,y,w,h) to (xc,yc,w/2,h/2).
rectcoll            -- Check overlap of two rectangles.
RMSE                -- Root Mean Square of Errors.
"""

from math import log10

from numpy import float64, square, sqrt


def linefunc(X1, X2, Y1, Y2):
    """Construct a 1D linear function (y=a*x+b), based on two points."""
    a = (Y2-Y1) / (X2-X1)
    b = Y1 - a*X1
    return lambda X: a*X+b


def roundsignificant(x, n):
    """Round x to n significant digits."""
    if x == 0:
        return 0
    else:
        return round(x, -int(log10(abs(x))) + n-1)


def roundas(x, n):
    """Round x to nearest multiple of n."""
    return n * round(x/n)


def maybeint(x):
    """Convert x to int if it has no trailing decimals."""
    if x % 1 == 0:
        x = int(x)
    return x


def rectmid(a):
    """Convert rectangle from (x, y, w, h) to (xc, yc, w/2, h/2)."""
    return (a[0]+a[2]/2, a[1]+a[3]/2, a[2]/2, a[3]/2)


def rectcoll(a, b):
    """Check if two rectangles (x, y, w, h) overlap/collide."""
    ac = rectmid(a)
    bc = rectmid(b)
    xcol = abs(ac[0]-bc[0]) <= ac[2]+bc[2]
    ycol = abs(ac[1]-bc[1]) <= ac[3]+bc[3]
    return (xcol and ycol)


def RMSE(SR, HR):
    """Compute Root Mean Square of Errors."""
    sqerr = square(float64(SR) - float64(HR))
    return sqrt(sqerr.mean())
