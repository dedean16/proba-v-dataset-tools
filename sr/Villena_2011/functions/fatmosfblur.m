
function h = fatmosfblur(R,delta,nr,nc)

if (mod(nr,2)==0 ) 
    nr= nr +1;
end

if (mod(nc,2)==0 )
    nc= nc +1;
end


centror=round(nr/2);
centroc=round(nc/2);

ys=centror-(1:nr);
ys=ys'; ys = repmat(ys,1,nc);

xs=centroc -(1:nc);
xs = repmat(xs,nr,1);

rs=double(xs.*xs + ys.*ys);

h= (rs*R^-2 +1).^(-delta);

h=h/sum(sum(h));