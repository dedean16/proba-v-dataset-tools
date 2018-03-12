from subprocess import call
from threading import Thread

# Coordinate argument constructor - builds URL coords argument
def coords(roi):
    return str(roi['xll']) +','+ str(roi['yll']) +','+ str(roi['xur']) +','+ str(roi['yur'])

# Threaded wget database fetcher class
class wgetthread(Thread):
    # Initialise thread
    def __init__(self, cfg, product):
        Thread.__init__(self)
        self.cfg   = cfg
        self.product    = product
    
    # Run thread
    def run(self):
        # Get relevant cfg variables
        cfg = self.cfg
        product  = self.product

        year     = cfg['year']
        month    = cfg['month']
        ROI      = cfg['ROI']
        
        wgetpath = cfg['wgetpath']
        datapath = cfg['datapath']
        baseurl  = cfg['baseurl']
        
        username = cfg['username']
        password = cfg['password']
        

        # Construct URL
        url = baseurl + product + str(year) + '/' + str(month) + '/?coord=' + coords(ROI)
        
        # Fetch data using wget
        call([wgetpath, '-r', '--user=' + username, '--password=' + password, '-P' + datapath, '-nH', '-q', '--show-progress', '--reject=*index.html*,/image/',  url])
