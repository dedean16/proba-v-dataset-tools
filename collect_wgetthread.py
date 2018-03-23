import os
import sys
from time import time, sleep
from subprocess import call
from threading import active_count, Thread, get_ident

# Get total size of a folder
def get_dirsize(start_path):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            total_size += os.path.getsize(fp)
    return total_size


# Print file size as rounded string in B, KB, MB, GB or TB
def sizestr(sizebytes):
    if sizebytes < 10**3:
        return '{}B'.format(sizebytes)
    elif sizebytes < 10**6:
        return '{}KB'.format(round(sizebytes/10**3))
    elif sizebytes < 10**9:
        return '{}MB'.format(round(sizebytes/10**6))
    elif sizebytes < 10**12:
        return '{}GB'.format(round(sizebytes/10**9))
    else:
        return '{}TB'.format(round(sizebytes/10**12))


# Coordinate argument constructor - builds URL coordstr argument
def coordstr(roi):
    return str(roi['xll']) +','+ str(roi['yll']) +','+ str(roi['xur']) +','+ str(roi['yur'])

# Threaded wget database fetcher class
class wgetthread(Thread):
    # Initialise thread
    def __init__(self, cfg, paths, product):
        Thread.__init__(self)
        self.cfg     = cfg
        self.paths   = paths
        self.product = product
    
    # Run thread
    def run(self):
        # Get relevant cfg variables
        cfg     = self.cfg
        paths   = self.paths
        product = self.product

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
        
        # Fetch data using wget
        call([wgetpath, '-r', '--user=' + username, '--password=' + password, '-P' + datapath, '-nH', '-q', '-c', '--reject=*index.html*,*.tiff',  url])


# Threaded status terminal output
class wgetstatus(Thread):
    # Initialise thread
    def __init__(self, paths):
        Thread.__init__(self)
        self.paths = paths
    
    # Run thread
    def run(self):
        paths = self.paths
        
        # print('For detailed output, see wget-log.txt.')
        
        wgetdone   = False             # Break if this gets True
        starttime  = time()            # Start time of process
        startsize  = get_dirsize(paths['data']) # Start size of data folder
        
        # Output status of wget until all wget threads are done
        while True:
            
            # Calculate time elapsed
            Dtotsec = time() - starttime
            Dmin = int(Dtotsec / 60)
            Dsec = int(Dtotsec - Dmin * 60)
            
            # Count number of active threads
            nth = active_count()
            
            # Calculate data folder size and accumulated size since start
            dirsize  = get_dirsize(paths['data'])
            downsize = dirsize - startsize
            
            # Write terminal output
            sys.stdout.write('\r{} min {} sec  Threads: {}  Downloaded: {}  Data folder: {}   '.format(Dmin, Dsec, nth, sizestr(downsize), sizestr(dirsize)))
            sys.stdout.flush()
            
            # Check if wget threads have finished
            # (if so, only 2 threads should be left in total)
            wgetactive = (nth > 2)
            if wgetdone: break
            
            # Sleep till next iteration
            sleep(10)
            
            
        print('\n')
