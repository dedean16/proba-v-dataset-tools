#!/usr/bin/env python3
# Extra Mathematical functions

# Construct a 1D linear function (y=a*x+b), based on two points
def linefunc(X1, X2, Y1, Y2):
    a = (Y2-Y1) / (X2-X1)
    b = Y1 - a*X1
    return lambda X: a*X+b
