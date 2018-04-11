function Xconv = parimagecov(x, nh)
% x is a image of NxM size
% nh is PSF kerner size 
% - Let h be PSF kerner, then h.x = Xconv'*h(:), where h.x represents
% result of convolution h by x. 
[N,M] = size(x);
NM = N*M;

mh = (nh+1)/2;

for ic = 1: M
    iic = (ic-1)*N;
    parfor irw = 1: N%#ok<*PFNST>
        xx = circshift(x,[mh-irw mh-ic]);
        xc = xx(1:nh,1:nh);
        Xconv(:,iic+irw)=xc(:);
       
    end
end
        
    