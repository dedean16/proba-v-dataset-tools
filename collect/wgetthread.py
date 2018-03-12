from subprocess import call
from threading import Thread

# Coordinate argument constructor - builds URL coords argument
def coords(roi):
    return str(roi['xll']) +','+ str(roi['yll']) +','+ str(roi['xur']) +','+ str(roi['yur'])

# Threaded wget database fetcher class
class wgetthread(Thread):
    # Initialise thread
    def __init__(self, settings, product):
        Thread.__init__(self)
        self.settings   = settings
        self.product    = product
    
    # Run thread
    def run(self):
        # Get relevant settings variables
        settings = self.settings
        product  = self.product

        year     = settings['year']
        month    = settings['month']
        ROI      = settings['ROI']
        
        wgetpath = settings['wgetpath']
        datapath = settings['datapath']
        baseurl  = settings['baseurl']
        
        username = settings['username']
        password = settings['password']
        

        # Construct URL
        url = baseurl + product + str(year) + '/' + str(month) + '/?coord=' + coords(ROI)
        
        # Fetch data using wget
        call([wgetpath, '-r', '--user=' + username, '--password=' + password, '-P' + datapath, '-nH', '-q', '--show-progress',  url])
