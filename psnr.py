"""
Video Quality Metrics
Copyright (c) 2014 Alex Izvorski <aizvorski@gmail.com>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


=== modified by Daniel Cox ===
The PIXEL_MAX was a fixed number. Now the bit depth adjusted. It will
still default to 8 bits => MAX=255.
"""

import numpy
import math

def psnr(img1, img2):
    mse = numpy.mean( (img1 - img2) ** 2 )
    if mse == 0:
        return 100
        
    # Determine bit depth. 16 for uint16, 8 for uint8 and others
    bitdepth = 8
    if img1.dtype == 'uint16':
        bitdepth = 16
    elif img1.dtype != 'uint8':
        print('Unsupported bit depth for image 1: {}'.format(img1.dtype))
        print('Bit depth = 8 will be used.')
    
    if img1.dtype != img2.dtype:
        print('Bit depths not the same! {} and {}'.format(img1.dtype, img2.dtype))
        print('Will use bitdepth of image 1: {}'.format(img1.dtype))
        
    PIXEL_MAX = 2**bitdepth - 1
    
    return 20 * math.log10(PIXEL_MAX / math.sqrt(mse))
