function Xconv = imagecov(x, nh)
% x is a image of NxM size
% nh is PSF kerner size 
% - Let h be PSF kerner, then h.x = Xconv'*h(:), where h.x represents
% result of convolution h by x. 
[N,M] = size(x);
NM = N*M;
x = circshift(x,[(nh+1)/2-1, (nh+1)/2-1]);

for ic = 1: M
    for irw = 1: N

        xc = x(1:nh,1:nh);
        Xconv(:,(ic-1)*N+irw)=xc(:);
        x = circshift(x,[-1 0]);
    end
    x = circshift(x,[0 -1]);
end
        
    