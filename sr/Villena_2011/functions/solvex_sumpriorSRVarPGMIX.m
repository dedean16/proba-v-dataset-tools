function [x,out] = solvex_sumpriorSRVarPGMIX(y,opt,HRaxis,handles)
% Copyright (C) 2011  S. Villena, M. Vega, D. Babacan, J. Mateos, 
%                        R. Molina and  A. K. Katsaggelos
%
%    If you use this software to evaluate any of the methods, please cite 
%    the corresponding papers (see manual).
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.



    fprintf(opt.LogFile, 'Running SR with optimal distributions Super Gaussiana: filters sum\n');

fprintf(opt.LogFile, '--------------------------------------------------------------------\n');

%--- We adopt one observation and it is not down-sampled

%%%-----

opt.nopix = opt.N*opt.M;
nopix =opt.nopix;
nu = 1e-4;
N = opt.N;
M = opt.M;
softFilter =1.0

opt.numFilter = size(handles.f,2);
f= handles.f;

Mezclanw(1,1:opt.numFilter) = 1;
opt.Mezcla = Mezclanw;
clear Mezclanw


for i = 1:opt.numFilter
    F{i} = circconvmatx2(f{i}, opt.M, opt.N);

end


H = circconvmatx2(opt.h,opt.M,opt.N);


D = dwnsmpl_matrix(opt.M,opt.N,opt);
W = sparse([]);


[X Y] = meshgrid([-N/2:N/2-1],[-N/2:N/2-1]);
if M < N
    X = X(1:M,:);
    Y = Y(ceil((N-M)/2)+1:N-floor((N-M)/2),:);
elseif M > N
    [X Y] = meshgrid([-M/2:M/2-1],[-M/2:M/2-1]);
    X = X(:,ceil((M-N)/2)+1:M-floor((M-N)/2));
    Y = Y(:,1:N);
end
X = X(:);
Y = Y(:);
  
if opt.InitImgExists == 1,
	opt.sx = opt.sx0;
	opt.sy = opt.sy0;
	opt.theta = opt.theta0;
else
	opt.sx = opt.sx_init;
	opt.sy = opt.sy_init;
	opt.theta = opt.theta_init;
end

% normalice y 
y=y/max(y);
%% If the registration is not accurate, estimate the registration first 
if ~opt.Real,
    betak(1:opt.L) = 1;%1/opt.sigma^2;
    if opt.EstimateRegistration,
        
        [ys,yvecs] = unwrapLR(y,opt);
        x = imresize(ys{1}, opt.res, 'bicubic'); % Start with a bicubic interpolated image to get a reference frame
        x=x(:);
        opt.M =  handles.opt.m;
     
        opt.N =  handles.opt.n; % For the initial registration 
        xl = ys{1};
        xl = xl(:);

     
      [opt,Lambdas] = EstimateMov(xl, opt,y,1,1,0,betak);
       for k = 2:opt.L

            opt.sx(k) = opt.sx(k)*double(opt.res);
            opt.sy(k) = opt.sy(k)*double(opt.res);
       end
       opt.M =  opt.M*double(handles.opt.res);
       opt.N =  opt.N*double(handles.opt.res);
    end
end % real 
    
  
 if opt.Color & opt.Canal.Color > 0
       for k = 2:opt.L
        opt.sx(k) = opt.Canal.sx(k);
        opt.sy(k) = opt.Canal.sy(k);
        opt.theta(k) = opt.Canal.theta(k);
       end
 end
%% Calculate initial hyperparameters



[ys,yvecs] = unwrapLR(y,opt);


[x,alpha,betak(1)] = restoreSARmio(double(imresize(ys{1},opt.res,'bicubic')),opt.h,1.0e-06,50);
for k = 2:opt.L
    [xr,alpha,betak(k)] = restoreSARmio(double(imresize(ys{k},opt.res,'bicubic')),opt.h,1.0e-06,50);
    clear xr alpha
end 
clear x
x= double(imresize(ys{1},opt.res,'bicubic'));
x=x(:);


x = x/max(x);

if ~opt.Real,
    opt.xtrue = opt.xtrue/max(opt.xtrue(:));
     opt.xnormal =1;
end

if opt.ShowImages, 
    axes(HRaxis);
    imshow(reshape(x,[opt.M,opt.N]));
end


if ~opt.Real,
    
     if opt.xnormal,

     MSE = sum(sum( (x(:) - opt.xtrue(:)).^2 ) )/nopix; % caso  de x normalizada
    else
     MSE = sum( (x(:)/max(x(:)) - opt.xtrue(:)/max(opt.xtrue(:))).^2 ) /nopix;
    end
    PSNR = 10*log10(1/MSE);
    fprintf(opt.LogFile,'betak = \n');
    fprintf(opt.LogFile,'%g ',betak);
 
   fprintf(opt.LogFile,'\n MSE = %g, PSNR = %g\n',MSE,PSNR);
else
    
    fprintf(opt.LogFile,'betak = \n');
    fprintf(opt.LogFile,'%g ',betak);
    
end


%% Initial registration covariance matrices
for k=1:opt.L,
             
    Lambdas_p{k} = [1e-6  0.0   0.0;
                    0.0   1e-6  0.0;
                    0.0   0.0   1e-6]; 

	Lambdas_p{k} = [1e-6 1e-8 1e-8;
                  1e-8 1e-6  1e-8;
                  1e-8 1e-8 1e-6];

    Lambdas_p{k} = zeros(3);              
    
    
    Lambdas{k} = Lambdas_p{k};
    
end


%%%%%%%%%%%%%%%%Inicialitation of matrix A
%% Coeficientes lambda_prior(i), alfas(i), betak ya estimado, po ->

   
         

        [x,out] = solvex_2PSG(x,y,opt,F,H,D,X,Y,betak,Lambdas,handles,HRaxis);
        

        
       
    

end
function [x, out] = solvex_2PSG(x,y,opt,F,H,D,X,Y,betak,Lambdas,handles,HRaxis)
    
opt.nopix = opt.N*opt.M;
nopix =opt.nopix;
nu = 1e-4;
N = opt.N;
M = opt.M;


        
betaW = 0;
for i=1:opt.L
    
    [C, O11, O22, O33 , O12, O13 O23] = AproxBili(opt,D,H,X, Y,i);
    W= D*H*C;
   betaW = betaW + betak(i)*spdiags(W'*W,0); 
end
 for i = 1:opt.numFilter
            Xcjc = (F{i}*x).^2;
           
            A{i} = 1./(Xcjc+ 1./(1 +betaW+eps));
          
         
  end
clear HtH betaW W
%%%%%%%%%%%%%%%%%%%%%

xconv = 1;
maxPSNR = 0;
maxPSNR_x = x;
maxPSNR_it = 1;
maxPSNR_sx = opt.sx;
maxPSNR_sy = opt.sy;
maxPSNR_theta = opt.theta;
minERROR = 1.e+10;
ERRORmaxPSNR = 1.e+10;
PSNRminERROR = 0;
mejor = 0;
maxA = A;

for i=1:opt.maxit,
    fprintf(opt.LogFile,'\n-------------------------------------------------------------------\n');
    fprintf(opt.LogFile,'Iteration %d\n',i);
  
     set(handles.text_Number_iteration,'String',i); 
    oldx = x(:);
    history_CPU(i) = cputime;

    %% Estimate the image

    % PCG
    
   [Sigma_inv, rhs, W]= covarianza(opt,D,H,F,A,y, Lambdas, betak, X, Y);
   if i == 1
     value_degradation_old = norm(y-W*x,2);
   end
    fprintf(opt.LogFile,'Finished calculating Sigma registration terms\n');

    fprintf(opt.LogFile,'Running PCG to estimate the image\n');
    
    [x,flag,relres,iter] = pcgmod(Sigma_inv,rhs,opt.PCG_thr,opt.PCG_maxit,[],[],oldx, opt.PCG_minit);
    
    fprintf(opt.LogFile,'PCG returned the solution at %d iterations, flag = %d\n',iter, flag);
    
    
   value_degradation = norm(y-W*x,2);
   error_mean = mean(abs(y-W*x)*256)
   error_std = std(abs(y-W*x)*256)
    %% Estimate the registration parameters
     if opt.ApproxSigma,
            Sigma = 1./spdiags(Sigma_inv,0);
            Sigma = spdiags(Sigma, 0, nopix, nopix);
     else
            Sigma = inv(Sigma_inv);
      end
    if opt.EstimateRegistration & opt.Canal.Color == 0, 
        fprintf(opt.LogFile,'Estimating the registration\n');
       
         [opt,Lambdas] = EstimateMov(x, opt,y,D,H, Sigma, betak);
     

    end
    
    %% Estimate the hyperparameters
    if  opt.FixedParameters == 0,
        fprintf(opt.LogFile,'Estimating the hyperparameters\n');
        [A,betak] =...
        updateparameters(opt,F,A,x,H, W,D,y,betak,X,Y,Sigma_inv, Lambdas);
    
    end
       
  
    xconv = norm(x - oldx)/norm(oldx);
    
     ERROR = norm(y-W*x,2);
    
     history_CPU(i) = cputime-history_CPU(i); 
     
    if ~opt.Real, 
      
        if opt.xnormal,
     
            MSEs(i) = sum(sum( (x(:) - opt.xtrue(:)).^2 ) )/nopix; % normalizada x
        else
            MSEs(i) = sum(sum( (x(:)/max(x(:)) - opt.xtrue(:)/max(opt.xtrue(:))).^2 ) )/nopix;    
        end
        MSES = MSEs(i);
        PSNRs(i) = 10*log10(1/MSEs(i));
        
        PSNRS = PSNRs(i);
        set(handles.text_mse2,'String',num2str(MSEs(i)));
         set(handles.text_psnr2,'String',num2str(PSNRs(i),'%f dB'));
        
        if i > 1 
            if PSNRs(i-1) <= PSNRs(i)
                mejor = 1;
            else
                mejor =0;
            end
        end
            

        if PSNRs(i) > maxPSNR,
            maxPSNR = PSNRs(i);
            maxPSNR_x = x;
            maxPSNR_it = i;
            maxPSNR_sx = opt.sx;
            maxPSNR_sy = opt.sy;
            maxPSNR_theta = opt.theta;
            ERRORmaxPSNR = ERROR;
             maxBetak =betak;
            maxA = A;
        
            
        end

        svec = [opt.theta(:); opt.sx(:); opt.sy(:)];
        svec_true = [opt.theta_true(:); opt.sx_true(:); opt.sy_true(:)];
       
        sNMSEs(i) = (norm(svec-svec_true)^2);
   
    %%%%%%%%%%%%%%%%%%
   
    if ERROR < minERROR
        minERROR = ERROR;
        PSNRminERROR = PSNRs(i);
    end
    else %end Real
         set(handles.value_degradation,'String',num2str(value_degradation));
         if value_degradation_old-value_degradation > 0
             set(handles.value_degradationd,'String','LOW');
         else
             set(handles.value_degradationd,'String','UP');
         end
         value_degradation_old = value_degradation;  
          if opt.KeepHistory %exist('history_x','var'),
             history_value_degradation{i}=value_degradation;
        end
    
    %%%%%%%%%%%%%%%%%%
   end 
    if opt.WriteImages & mod(i,10) == 0,
        
        if opt.xnormal,
        imwrite(reshape(uint8(x*256),[opt.M,opt.N]),sprintf('x_RegErr_var%d_sigma%g_init%d_it%d.png',strcmp(opt.method,'variational'), opt.sigma, opt.DIVIDE_U, i));
        else
         imwrite(reshape(uint8(x),[opt.M,opt.N]),sprintf('x_RegErr_var%d_sigma%g_init%d_it%d.png',strcmp(opt.method,'variational'), opt.sigma, opt.DIVIDE_U, i));   
        end
    end
            
    if ~opt.Real, 
        fprintf(opt.LogFile,'betak = \n');
        fprintf(opt.LogFile,'%g ',betak);
        fprintf(opt.LogFile,'\nxconv = %g, PSNR = %g, MSE = %g, sNMSE = %g\n',...
            xconv, PSNRs(i), MSEs(i), sNMSEs(i));
    else
        fprintf(opt.LogFile,'betak = \n');
        fprintf(opt.LogFile,'%g ',betak);
        fprintf(opt.LogFile,'\nxconv = %g\n',xconv);
    end
%     pause
    
%   
     if opt.ShowImages, 
         set(handles.text_Msr,'String',M);
        set(handles.text_Nsr,'String',N);
        
       if opt.Color & opt.Canal.Color > 0
           xxc=zeros(opt.M, opt.N,3);
           xxc(:,:,opt.Canal.Color) = reshape(x,[opt.M,opt.N]);
            axes(HRaxis);
            imshow(xxc);
            clear xxc
       else

        axes(HRaxis), imshow(reshape(x,[opt.M,opt.N]));
       end
   
    end

    if opt.KeepHistory,
        history_x{i} = x;
     
        history_betak{i} = betak;
        history_theta{i} = opt.theta;
        history_sx{i} = opt.sx;
        history_sy{i} = opt.sy;
        history_Lambda{i} = Lambdas;
       
    end
    
     opt.cancel = get(opt.ref_cancel,'Value');
    if opt.cancel,
        break;
    end
    if xconv < opt.thr % | abs(dif_error) <= 0.05
  
     break;
    end
     if opt.Canal.Color> 0 & i == opt.Canal.maxit
        break;
    end
    if mejor ==0 & i>5
        break
    end
end

out.betak = betak;

out.Lambdas = Lambdas;
out.xconv = xconv;
out.theta = opt.theta;
out.sx = opt.sx;
out.sy = opt.sy;
out.it = i;
out.history_CPU = history_CPU;
 if opt.KeepHistory %exist('history_x','var'),
        out.history_x =history_x;
        out.history_value_degradation= history_value_degradation;
  end

if ~opt.Real, 
    out.MSEs = MSEs;
    out.MSE = MSEs(end);
    out.PSNRs = PSNRs;
    out.PSNR = PSNRs(end);
    out.sNMSEs = sNMSEs;
    out.sNMSE = sNMSEs(end);
    out.maxPSNR = maxPSNR;
    out.maxPSNR_x = reshape(maxPSNR_x,M,N);
    out.maxPSNR_it = maxPSNR_it;
    out.maxPSNR_sx = maxPSNR_sx;
    out.maxPSNR_sy = maxPSNR_sy;
    out.maxPSNR_theta = maxPSNR_theta;
    out.minERROR = minERROR;
    out.PSNRminERROR = PSNRminERROR;
    out.ERRORmaxPSNR = ERRORmaxPSNR;
    out.maxA = maxA;
    out.maxBetak = maxBetak;
    
   
end

if opt.KeepHistory,
    varargout{1} = history_x;
   
    varargout{2} = history_betak;
    varargout{3} = history_theta;
    varargout{4} = history_sx;
    varargout{5} = history_sy;
    varargout{6} = history_Lambda;
     
end
end


function [Sigma_inv, rhs, W]= ...
    covarianza(opt,D,H,F,A,y, Lambdas, betak, X, Y)
nopix = opt.nopix;
 Sigma_inv = sparse(nopix,nopix);
 [ys,yvecs] = unwrapLR(y,opt);
   
    W = sparse([]);
    M = opt.M; N = opt.N;
   
    rhs = 0;
   
   
    for k=1:opt.L,
        
      [C,O11, O22 O33 O12 O13 O23] = AproxBili(opt,D,H, X,Y, k);
      
        B = D*H*C;
       
        W = [W;B ];
       
        
        rhs = rhs + betak(k)*B'*yvecs{k};
        Sigma_inv = Sigma_inv + betak(k)*B'*B;
        

            Lambda = Lambdas{k};
            Sigma_inv = Sigma_inv + betak(k) * Lambda(1,1)*O11 + betak(k) *Lambda(2,2)*O22 + betak(k) *Lambda(3,3)*O33 ...
                    + betak(k) *2*Lambda(1,2)*O12 + betak(k) *2*Lambda(1,3)*O13 + betak(k) *2*Lambda(2,3)*O23;
            
        
        
    end
   for k= 1:opt.numFilter
     if opt.Mezcla(k) > 0   
       Sigma_inv = Sigma_inv + (F{k}'*spdiags(A{k},0,nopix,nopix))*F{k};

     end
   end
    
end




function [A,betak] =...
        updateparameters(opt,F,A,x,H, W,D,y,betak,X,Y, Sigma_inv, Lambdas)
    
     nopix = opt.nopix;
  
   
    if opt.ApproxSigma,
        
        Sigma = spdiags(1./spdiags(Sigma_inv,0),0,nopix,nopix);
        
       
    else
       
        Sigma = inv(Sigma_inv);
        
    end
     
 
    
%                    
        for k = 1:opt.numFilter
             
             Xcjc = (F{k}*x);
             if opt.ApproxSigma,
            
                    A{k} = 1./ (Xcjc.^2+(spdiags(Sigma,0)'*(F{k}.^2)')' );
             else
                  A{k} = 1./ (Xcjc.^2+(spdiags(Sigma*F{k}'*F{k}) ));
             end
%              
        end

%---------------------------------
 
        e = y-W*x+ eps;
       
        nopixlr = size(e,1);
        
        % Different noise variances??
        if strcmp(opt.noise_estimate, 'SEPARATE')
            [temp, es] = unwrapLR(e,opt);
            
            for k=1:opt.L,
                esk(k) = sum(es{k}.^2);
                
                if strcmp(opt.method,'variational'),
                    
                    [C, O11, O22 O33 O12 O13 O23] = AproxBili(opt,D,H, X,Y, k);
                    B = D*H*C;
                     
                     traceBkSigma  = sum(sum(Sigma*B'*B));
                    
                    Lambda = Lambdas{k};
                    xOx = Lambda(1,1)*x'*O11*x + Lambda(2,2)*x'*O22*x + Lambda(3,3)*x'*O33*x ...
                        + 2*Lambda(1,2)*x'*O12*x + 2*Lambda(1,3)*x'*O13*x + 2*Lambda(2,3)*x'*O23*x;
                    traceOSigma = sum ( spdiags( Lambda(1,1)*O11*Sigma + Lambda(2,2)*O22*Sigma + Lambda(3,3)*O33*Sigma ...
                        + 2*Lambda(1,2)*O12*Sigma + 2*Lambda(1,3)*O13*Sigma + 2*Lambda(2,3)*O23*Sigma, 0) );
                    if opt.verbose,
                       fprintf(opt.LogFile,'k = %d, e = %g, xOx = %g, traceBkSigma = %g, traceOSigma = %g\n', k ,...
                           esk(k),full( xOx), full(traceBkSigma), full(traceOSigma));
                    end
                  
                 
                    esk(k) = esk(k) + traceBkSigma + traceOSigma + xOx;
                 
                      betak(k) = nopixlr / esk(k);
                else
                    if opt.verbose,
                        fprintf(opt.LogFile,'k = %d, e = %g\n', k , esk(k));
                    end
                    betak(k) = nopixlr / esk(k);
                 
                end
                if opt.FixedBeta
                      betak(1:end)=1/opt.sigma;
                 end
                
            end
        else
            e = sum(e.^2);
            betak = (length(y)) / e * ones(opt.L,1);
            if opt.FixedBeta
                      betak(1:end)=1/opt.sigma;
             end
        end
    


%-----------------------------------
        
   
    
end

    function  [C, O11, O22 O33 O12 O13 O23] = AproxBili(opt,D,H, X,Y, k)
         nopix = opt.nopix;
         M = opt.M; N = opt.N;
    
          [C,Lbl,Lbr,Ltl,Ltr,a,b]  = warp_matrix_bilinear(opt.sx(k),opt.sy(k),opt.theta(k),M,N);
        % Create the terms related to the uncertainty arising from registration
       
            P1 = spdiags( -X*sin(opt.theta(k)) - Y*cos(opt.theta(k)), 0 , nopix,nopix);
            P2 = spdiags( +X*cos(opt.theta(k)) - Y*sin(opt.theta(k)), 0 , nopix,nopix);

            O{2} = spdiags((1-b), 0, nopix,nopix)*(Ltr-Ltl) + spdiags(b, 0, nopix,nopix)*(Lbr-Lbl); %M1
            O{3} = spdiags((1-a), 0, nopix,nopix)*(Lbl-Ltl) + spdiags(a, 0, nopix,nopix)*(Lbr-Ltr); %M2
            
            O{1} = P1*O{2} + P2*O{3};

            O{1} = D* H*O{1};
            O{2} = D* H*O{2};
            O{3} = D* H*O{3};

            O11 = O{1}'*O{1};
            O22 = O{2}'*O{2};
            O33 = O{3}'*O{3};
            O12 = O{1}'*O{2};
            O13 = O{1}'*O{3};
            O23 = O{2}'*O{3};
            clear O;
    end
        

    function [opt, Lambdas] = EstimateMov(x, opt, y, A, H, Sigma, betak) 
        
        
        [ys,yvecs] = unwrapLR(y,opt);
        
       

        fprintf(opt.LogFile,'Estimating the registration\n');
         Lambdas{1}=zeros(3);

        %for k=1:opt.L,
        for k=2:opt.L,    
            fprintf(opt.LogFile,'\n********************************************\n');
            fprintf(opt.LogFile,'Image %d\n',k);
            [newsk, Lambdak,yhatk] = LKvar(x, k, yvecs{k}, Sigma , A,H, zeros(3), betak(k), opt);

            if ~opt.Real,
                sk_true = [opt.theta_true(k); opt.sx_true(k); opt.sy_true(k)];
                sk_true = sk_true(:);
            end

            fprintf(opt.LogFile,'Initial registration   sx = %g, sy = %g, theta = %g\n',opt.sx_init(k),opt.sy_init(k),opt.theta_init(k)/pi*180);
            fprintf(opt.LogFile,'Previous registration  sx = %g, sy = %g, theta = %g\n',opt.sx(k),opt.sy(k),opt.theta(k)/pi*180);
            fprintf(opt.LogFile,'Estimated registration sx = %g, sy = %g, theta = %g\n',newsk(2),newsk(3),newsk(1)/pi*180);
            if ~opt.Real,
                fprintf(opt.LogFile,'True registration      sx = %g, sy = %g, theta = %g\n',opt.sx_true(k),opt.sy_true(k),opt.theta_true(k)/pi*180);
                fprintf(opt.LogFile,'Estimation error NMSE = %g\n', norm(newsk-sk_true)^2);
            end

            opt.theta(k) = newsk(1);
            opt.sx(k) = newsk(2);
            opt.sy(k) = newsk(3);
            Lambdas{k} = Lambdak;
            %             pause
        end
        
   end