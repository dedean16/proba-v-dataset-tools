function res = fusionarColor(luminancia,imagenRGB)
    % Luminancia -> it is the obtained reconstruction image in Black and white ,
    % imagenRGB -> it is the original color image.
    % res -> it represents the reconstructed  image in color.
    
    [nr,nc,cc]= size(luminancia);
    [nro,nco,cc] = size(imagenRGB);
    dfr = 0;
    dfc = 0;
    if nr > nco 
        dfr= (nr-nro)/2;
    end
    if nc > nco
        dfc = (nc-nco)/2;
    end
    lu = luminancia(dfr+1:dfr+nro,dfc+1:dfc+nco);
    res=rgb2ycbcr(imagenRGB);
    res(:,:,1)=lu;
    res = ycbcr2rgb(res);
end