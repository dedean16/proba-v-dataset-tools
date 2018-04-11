
function Ht = Tcent_nucleus2fft(spkernel, nr, nc)

    
[nrk nck]=size(spkernel);

%% ajustar tama�o
    if(( nrk> nr) || ( nck> nc))
           border= round( max ( 0 , ([nrk nck] - [nr nc]) ) / 2);
           inter=spkernel( 1+border(1):nrk-border(1) , 1+border(2):nck-border(2));
             fac=sum(spkernel(:))/sum(inter(:));
             spkernel=inter*fac;  
             [nrk nck]=size(spkernel);
             clear inter 
    end
    
   
    
%% Poner el n�cleo centrado en el origen y calcular la fft2

           h = zeros(nr, nc);
            h(1:nrk , 1:nck ) = spkernel(:,:);
            disp=floor( ([nrk nck] + 1) / 2)- [nrk nck] ;
            h =circshift(h,disp);
           Ht = fft2(h);    
end

