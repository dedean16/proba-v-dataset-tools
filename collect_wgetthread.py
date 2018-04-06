import os
import sys
from time import time, sleep
from subprocess import call
from threading import active_count, Thread, get_ident

from custom_functions import *


# Coordinate argument constructor - builds URL coordstr argument
def coordstr(roi):
    return str(roi['xll']) +','+ str(roi['yll']) +','+ str(roi['xur']) +','+ str(roi['yur'])

# Threaded wget database fetcher class
class wgetthread(Thread):
    # Initialise thread
    def __init__(self, cfg, paths, product, filesdone=''):
        Thread.__init__(self)
        self.cfg     = cfg
        self.paths   = paths
        self.product = product
        self.filesdone = filesdone
    
    # Run thread
    def run(self):
        # Get relevant cfg variables
        cfg     = self.cfg
        paths   = self.paths
        product = self.product
        filesdone = self.filesdone

        year     = cfg['year']
        month    = cfg['month']
        ROI      = cfg['ROI']
        baseurl  = cfg['baseurl']
        
        username = cfg['username']
        password = cfg['password']
        
        wgetpath = paths['wget']
        datapath = paths['data']
        

        # Construct URL
        url = baseurl + product + str(year) + '/' + str(month) + '/?coord=' + coordstr(ROI)
        
        sleep(0.3)  # Give wgetstatus some time to calculate data folder size
        
        # Fetch data using wget
        call([wgetpath, '-r', '--user=' + username, '--password=' + password, '-P' + datapath, '-nH', '-q', '--reject=*.html*,*.tiff,*.png,*.pdf'+filesdone,  url])


# Threaded status terminal output
class wgetstatus(Thread):
    # Initialise thread
    def __init__(self, paths, nfilesdone=0):
        Thread.__init__(self)
        self.paths = paths
        self.nfilesdone = nfilesdone
    
    # Run thread
    def run(self):
        paths = self.paths
        nfilesdone = self.nfilesdone
        
        # Recalculate folder size every itrecalcsize iterations
        itrecalcsize = 15
        downsize = 0                    # Will hold the downloaded size
        
        print('\nStarting wget downloads...')
        print('Rejecting {} previously processed files.\n'.format(nfilesdone))
        print('Elapsed:        Threads:  Downloaded:  Data folder:  Speed:')
        
        wgetdone   = False              # Break if this gets True
        starttime  = time()             # Start time of process
        startsize  = get_dirsize(paths['data']) # Start size of data folder
        
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
                dirsize      = get_dirsize(paths['data'])   # Tot. folder size
                lastdownsize = downsize                     # Last downl size
                downsize     = dirsize - startsize          # New downl size
                downspeed    = (downsize - lastdownsize) / itrecalcsize
                i = 1                                       # Reset iter. num
            
            # Write terminal output
            sys.stdout.write('\r{:>3} min {:>2} sec  {:2}        {:6}       {:6}        {:9}'.format(Dmin, Dsec, nth, sizestr(downsize), sizestr(dirsize), sizestr(downspeed)+'/s'))
            sys.stdout.flush()
            
            # Check if wget threads have finished
            # (if so, only 2 threads should be left in total)
            wgetdone = (nth <= 2)
            if wgetdone: break
            
            # Sleep till next iteration
            sleep(1)
            i += 1
            
        print('\n')
