#!/usr/bin/env python3
"""
Thread classes for the collect script.

wgetthread -- wget fetcher thread class. Fetches HDF5 files from server.
wgetstatus -- Threaded wget database status class. Reports status of downloads.
coordstr -- String representation of coordinates.
"""

import sys
from time import time, sleep
from subprocess import call
from threading import active_count, Thread

from custom_functions import get_dirsize, sizestr


# Coordinate argument constructor - builds URL coordstr argument
def coordstr(roi):
    """String representation of coordinates. Also for URL arguments."""
    return str(roi['xll']) + ',' + str(roi['yll']) + ','\
        + str(roi['xur']) + ',' + str(roi['yur'])


class wgetthread(Thread):
    """Threaded wget database fetcher class. Fetch HDF5 files from server."""

    def __init__(self, cfg, paths, product, filesdone=''):
        """Initialise thread parameters."""
        Thread.__init__(self)
        self.cfg = cfg
        self.paths = paths
        self.product = product
        self.filesdone = filesdone

    # Run thread
    def run(self):
        """Fetch files from server."""
        # Get relevant cfg variables.
        cfg = self.cfg
        paths = self.paths
        product = self.product
        filesdone = self.filesdone

        year = cfg['year']
        ROI = cfg['ROI']
        baseurl = cfg['baseurl']
        username = cfg['username']
        password = cfg['password']
        wgetpath = paths['wget']
        datapath = paths['data']

        sleep(0.3)  # Give wgetstatus some time to calculate data folder size

        for month in cfg['months']:
            # Construct URL
            url = baseurl + product + str(year) + '/' + str(month)\
                + '/?coord=' + coordstr(ROI)

            # Fetch data using wget
            call([wgetpath, '-r', '--user='+username, '--password='+password,
                  '-P'+datapath, '-nH', '-q',
                  '--reject=*.html*,*.tif,*.tiff,*.png,*.pdf'+filesdone,  url])


# Threaded status terminal output
class wgetstatus(Thread):
    """Threaded wget database status class. Reports status of downloads."""

    def __init__(self, paths, nfilesdone=0):
        """Initialise wget status thread."""
        Thread.__init__(self)
        self.paths = paths
        self.nfilesdone = nfilesdone

    def run(self):
        """Run wget status thread. Report DB size and download progress."""
        paths = self.paths
        nfilesdone = self.nfilesdone

        # Will recalculate folder size every itrecalcsize iterations
        itrecalcsize = 15
        downsize = 0                            # init downloaded size

        print('\nStarting wget downloads...')
        print('Rejecting {} previously processed files.\n'.format(nfilesdone))
        print('Elapsed:        Threads:  Downloaded:  Data folder:  Speed:')

        wgetdone = False                        # Break if this gets True
        starttime = time()                      # Start time of process
        startsize = get_dirsize(paths['data'])  # Start size of data folder

        i = itrecalcsize
        # Output status of wget until all wget threads are done
        while True:

            # Calculate time elapsed
            Dtotsec = time() - starttime
            Dmin = int(Dtotsec / 60)
            Dsec = int(Dtotsec - Dmin * 60)

            # Count number of active threads
            nth = active_count()

            # Recalculate data folder size every itrecalcsize iterations
            if i == itrecalcsize:
                # Calculate data folder size and accumulated size since start
                dirsize = get_dirsize(paths['data'])        # Tot. folder size
                lastdownsize = downsize                     # Last downl size
                downsize = dirsize - startsize              # New downl size
                downspeed = (downsize - lastdownsize) / itrecalcsize
                i = 1                                       # Reset iter. num

            # Write status as terminal output
            sys.stdout.write('\r{:>3} min {:>2} sec  {:2}        {:6}       {:6}        {:9}'.format(Dmin, Dsec, nth, sizestr(downsize), sizestr(dirsize), sizestr(downspeed)+'/s'))
            sys.stdout.flush()

            # Check if wget threads have finished
            # (if so, only 2 threads should be left in total)
            wgetdone = (nth <= 2)
            if wgetdone:
                break

            # Sleep till next iteration
            sleep(1)
            i += 1

        print('\n')
