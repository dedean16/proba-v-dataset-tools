%    SuperResolution: SuperResolution evaluation software
%    Copyright (C) 2011  S. Villena, M. Vega, D. Babacan, J. Mateos, 
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

function varargout = SuperResolutionv1(varargin)
% SUPERRESOLUTIONV1 M-file for SuperResolutionv1.fig
%      SUPERRESOLUTIONV1, by itself, creates a new SUPERRESOLUTIONV1 or raises the existing
%      singleton*.
%
%      H = SUPERRESOLUTIONV1 returns the handle to a new SUPERRESOLUTIONV1 or the handle to
%      the existing singleton*.
%
%      SUPERRESOLUTIONV1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SUPERRESOLUTIONV1.M with the given input arguments.
%
%      SUPERRESOLUTIONV1('Property','Value',...) creates a new SUPERRESOLUTIONV1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SuperResolutionv1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SuperResolutionv1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SuperResolutionv1

% Last Modified by GUIDE v2.5 03-Mar-2015 09:58:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SuperResolutionv1_OpeningFcn, ...
                   'gui_OutputFcn',  @SuperResolutionv1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SuperResolutionv1 is made visible.
function SuperResolutionv1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SuperResolutionv1 (see VARARGIN)


[s,mess,messid] = mkdir('tempSR');
handles.LRi = 0;
handles.opt.xtrue = 0;
handles.opt.L = 0;

handles.opt.sx_true = zeros(1,4);
handles.opt.sy_true = zeros(1,4);
handles.opt.theta_true_grad = zeros(1,4);

handles.opt.LR_exe = 0;


h=zeros(9);
h(5,5)=1;
save('tempSR/h_aux.mat','h');

addpath('functions');

% Choose default command line output for SuperResolutionv1
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SuperResolutionv1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SuperResolutionv1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_OHRI_SM.
function pushbutton_OHRI_SM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OHRI_SM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f_name,n_route,index]=uigetfile({'*.jpg;*.gif;*.tif;*.png'},'Open HR image...');

handles.opt.Color = 0;
if index == 1

    set(handles.text_Magnification_Factor,'Enable','On');
    set(handles.edit_Magnification,'Enable','On');
     set(handles.popupmenu_Warp,'Enable','On');


%% Initial values
    data = get(handles.uitable_warp,'Data');
    set(handles.uitable_warp,'ColumnEditable',logical(zeros(1,length(data))));
    handle.opt.menu_warp = 1;
      set(handles.text_NLR,'Enable','On');
     set(handles.edit_NLR,'Enable','On');
    set(handles.text_Magnification_Factor,'Enable','On');
    set(handles.edit_Magnification,'Enable','On');
    
    set(handles.popupmenu_feat,'Enable','Off');
    set(handles.uitable_warp,'Enable','Off');
    set(handles.edit_Magnification,'String','2');
    set(handles.edit_NLR,'String','4');
    handles.opt.res = 2;
    handles.opt.L= 4;
    
    filter =2;
    set(handles.popupmenu_Blur,'Value',2);
      set(handles.text_size_h,'Visible','On');
        set(handles.edit_size_h,'Visible','On');
        set(handles.text_varh,'Visible','Off');
        set(handles.edit_varh,'Visible','Off');
        set(handles.text_size_h,'String','Mask size (odd #):');
        set(handles.edit_Noise,'String','30');
         set(handles.edit_Noise,'Enable','on');
         
         set(handles.edit_NLR,'Enable','on');
         set(handles.edit_Magnification,'Enable','on');
         set(handles.edit_size_h,'String','3');
         set(handles.edit_size_h,'Enable','on');
         set(handles.popupmenu_Blur,'Enable','on');
         set(handles.popupmenu_Warp,'Enable','on');
         set(handles.radiobutton_var,'Enable','On');
        set(handles.radiobutton_SNR,'Enable','On');    
        handles.opt.SNR = 30;
       
        set(handles.pushbutton_LRG,'Enable','On');
  

%%
    
    imainfo = imfinfo([n_route f_name]);
    colorT = imainfo(1,1).ColorType;
    if strcmp(colorT,'indexed')
        [HRi,map] = imread([n_route f_name]);
        HRi = ind2rgb(HRi,map);
    else
        HRi = imread([n_route f_name]);
        
    end
    
    
    %Image restriction to gray scale
    if not(strcmp(colorT,'grayscale')) 
        handles.opt.Color=1;
        HRiColor = HRi;
        HRi = rgb2gray(HRi);
    end
     
   %--- Test if HRi is scuare
   [nf,nc]=size(HRi);
   set(handles.sizeHRsimuled,'Visible','On');
  set(handles.nfHRsimuled,'String',nf);
  set(handles.ncHRsimuled,'String',nc);
   set(handles.nfHRsimuled,'Visible','On');
   set(handles.ncHRsimuled,'Visible','On');

%--- End Test ---

    axes(handles.HRimage_SM);
    [handles.opt.M,handles.opt.N] = size(HRi);

    if handles.opt.Color == 1
        imshow(HRiColor);
    else
        imshow(HRi);
    end
    

    
    handles.opt.xtrue = double(HRi(:)); 
    handles.opt.HRi = double(HRi); 
    if handles.opt.Color == 1
        handles.opt.xtrueColor =double(HRiColor(:));
        handles.opt.HRiColor = HRiColor;
    end
    
else
    warndlg('No HR image selected')
end

%%%% Initial value of parameters handles.opt
handles.opt.L = 4;
handles.opt.res = 2;


handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_OLRI.

function pushbutton_OLRI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OLRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
    
    %n_ob = get(handles.LR_counter,'String');
    %n_ob = round(abs(str2num(n_ob)));
    n_ob = handles.n_ob;
    
    set(handles.LR_counter,'String',num2str(n_ob));

    if n_ob == 0 
        n_ob =1;
    end
    mat_format =0;
    handles.opt.Color = 0;
    if handles.opt.Open_Real 
        [f_name,n_route,index]=uigetfile({'*.jpg;*.gif;*.tif;*.png;*.mat'},'Open LR images...',...
            handles.opt.n_route);
      
    else
        [f_name,n_route,index]=uigetfile({'*.jpg;*.gif;*.tif;*.png;*.mat'},'Open LR images...');
    end
 
if index == 1
    
     if  f_name(length(f_name)-3:length(f_name)) == '.mat'
           mat_format = 1;
           
           [yk_img,f_name]=loadimage_mat(f_name,n_route);
           
            sformat = whos('yk_img');
            
            
           %%-----Color----- or B/N 
          
           if strcmp(sformat.class(1:3),'cel')
             if size(yk_img{1},3)== 3   
               % Color format
               handles.opt.Color = 1;
               nob_yk = sformat.size(2);
               yk_color = yk_img;
               handles.opt.y1Color= yk_color{1};
               clear yk_color
               for iob=1:nob_yk
                   yk_color(:,:,:,iob)=yk_img{iob}; % 4D normalized
               end
                   
               clear yk_img
               
               for iyk=1:nob_yk
                   yk_img(:,:,iyk) = rgb2gray(uint8(yk_color(:,:,:, iyk)));
               end
             else % cell format but grey images
                  nob_yk = sformat.size(2);
               yk_color = yk_img;
                clear yk_img
               for iob=1:nob_yk
                   yk_img(:,:,:,iob)=yk_color{iob}; % 4D normalized
               end
                   
               clear yk_color
             end
           elseif size(sformat.size,2)== 4
               handles.opt.Color = 1;
               nob_yk = sformat.size(4);
               yk_color = yk_img;
               handles.opt.y1Color= yk_color(:,:,:,1);
               clear yk_img
               
               for iyk=1:nob:yk
                   yk_img(:,:,iyk) = rgb2gray(uint8(yk_color(:,:,:,iyk)));
               end
           
          
           elseif strcmp(sformat.class(1:3),'dou') &  size(sformat.size,2)== 3
                   nob_yk = sformat.size(3);
               
           else
               mat_format =0;
               index = 0;
               err= errordlg('The file must contain a single variable of size (columns*row*n. observations) with all the observations')
               %             'Error This file image format must be (rows*columns*n. observations)')
              
           end
           
     end
    
    
    
    if handles.opt.Open_Real == 0 | mat_format
        handles.opt.n_route = n_route;
        handles.opt.Open_Real = 1;
    end
    
   if mat_format % file .mat
       respuesta = 'No ';
       if handles.opt.L >= 1
           respuesta=questdlg('You will lose all the previously loaded observations',...
           'Choice', 'Yes', 'No ', 'No ');
       end
      if respuesta == 'Yes' | handles.opt.L == 0
   
        handles.opt.n_route = n_route;
       [nf,nc,n_ob]= size(yk_img);
       handles.opt.L=n_ob;


        [handles.opt.m,handles.opt.n,handles.n_ob] = size(yk_img);
        y= [];
       
       for k = 1: n_ob
           yk=yk_img(:,:,k);
           
            yk= double(yk);
            yk= yk/(max(max(yk)));

            ys{k} =  yk; % Normalizated observation
            
            if handles.opt.Color % Normalizated Color observation
               LRi(:,:,1,k) = yk_color(:,:,1,k)/max(max(yk_color(:,:,1,k)));
               LRi(:,:,2,k) = yk_color(:,:,2,k)/max(max(yk_color(:,:,2,k)));
               LRi(:,:,3,k) = yk_color(:,:,3,k)/max(max(yk_color(:,:,3,k)));
            end



            yvecs{k} =double( yk(:));
            y = double([y; yk(:)]);

            handles.yvecs{k} = (yvecs{k});

            handles.y = y;
            npix = handles.opt.n*handles.opt.m;

             i=k;
             if handles.opt.Color ~= 1
                aux = y((i-1)*npix+1:i*npix); 
                LRi(:,:,1,i) = reshape(aux,[handles.opt.m,handles.opt.n]);
             end
            handles.LRi =    LRi;
        
            axes(handles.LRimages);
            set(handles.text_Mlr,'String',handles.opt.m);
            set(handles.text_Nlr,'String',handles.opt.n);
            set(handles.LR_counter,'String',i); 

            imshow(uint8(handles.LRi(:,:,:,i).*(255/max(max(max(handles.LRi(:,:,:,i)))))));


            handles.opt.y = y; 

           
       end
       handles.n_ob =n_ob+1;
        
      else
           warndlg('No image selected');
        
        
      end 
   else
    handles.opt.L=n_ob;
    
    imainfo = imfinfo([n_route f_name]);
    colorT = imainfo(1,1).ColorType;
    if strcmp(colorT,'indexed')
        handles.opt.Color =1;
        [yk,map] = imread([n_route f_name]);
        if n_ob == 1 & handles.opt.Color == 1
            handles.opt.y1Color = yk;
         end
        yk = ind2rgb(yk,map);
    else
        yk = imread([n_route f_name]);
    end
    
    
    %Image restriction to gray scale
    if not(strcmp(colorT,'grayscale')) 
        handles.opt.Color =1;
        if n_ob == 1 & handles.opt.Color == 1
            handles.opt.y1Color = yk;
        end
        yk = rgb2gray(yk);
    end
     
    axes(handles.LRimages);
    
   
        
    k=n_ob;
    
   
    
     %--- Test if HRi is scuare
    [nf,nc]=size(yk);


    % ----- End test ---
    [nf,nc]=size(yk);
    if n_ob == 1
         y= [];
         [handles.opt.m,handles.opt.n] = size(yk);
         
    else
        y = handles.y;
        LRi=handles.LRi;
    end
    control_error = 1; 
    if n_ob > 1
        if nf ~= handles.opt.m | nc ~= handles.opt.n
                errordlg('All The LR images must have the same size');
                control_error = 0;
        end
    end
    if control_error   
        k= n_ob;
        %----- Normalization of observations----
        yk= double(yk);
        yk= yk/(max(max(yk)));
        
        ys{k} =  yk; % Normalizated observation
        
        
        
        yvecs{k} =double( yk(:));
        y = double([y; yk(:)]);
        
        handles.yvecs{k} = (yvecs{k});

        handles.y = y;
        npix = handles.opt.n*handles.opt.m;

         i=handles.opt.L;
        aux = y((i-1)*npix+1:i*npix); 
       
        LRi(:,:,:,i) = reshape(aux,[handles.opt.m,handles.opt.n]);
        handles.LRi =    LRi;
   
        
        set(handles.text_Mlr,'String',handles.opt.m);
        set(handles.text_Nlr,'String',handles.opt.n);
        imshow(uint8(handles.LRi(:,:,:,i)*(255/max(max(handles.LRi(:,:,:,i))))));

        handles.opt.y = y; 
        
        n_ob = n_ob +1; 
        handles.n_ob = n_ob;
        
      
    end
   

end % 
else
 warndlg('No image selected');
    
end

if n_ob > 1
    
    set(handles.pushbutton_Save_LRI,'Enable','On');
    set(handles.pushbutton_ShowImages,'Enable','On');
end

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_Save_LRI.
function pushbutton_Save_LRI_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Save_LRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.mode == 2 % Simulation mode 
    [f_name,n_route,index]=uiputfile('*.png','Save LR images...');

    if index == 1
        if handles.LRi == 0
            fprintf('No images loaded');
        else
            handles.opt.LR_exe = 0;
            [D1,D2,D3,D4]=size(handles.LRi);

            if all(ismember('.png',f_name))
                [r_f_name,c_f_name]=size(f_name);
                f_name = f_name(:,1:c_f_name-4);
            end

            for i=1:D4
                imwrite(uint8(handles.LRi(:,:,:,i)),[n_route f_name num2str(i,'_%i.png')],'png');
                
            end
            imwrite(reshape(handles.opt.xtrue,handles.opt.M,handles.opt.N),...
                    [n_route f_name 'Original.png'],'png');
        end
    end
else % Real mode
    %% Enable SR panel
  
    set(handles.pushbutton_LRG,'Enable','Off');
    set(handles.popupmenu_SRmet,'Enable','On');
    set(handles.popupmenu_registered,'Enable','Off');
    set(handles.popupmenu_Blur_HR,'Enable','On');
     set(handles.popupmenu_Blur_HR,'Visible','On');
    handles.opt.res = 2; % initial factor value
    set(handles.edit_MFSR,'String',num2str(handles.opt.res));
    set(handles.edit_MFSR,'Enable','On');
    set(handles.ref_img, 'String',num2str(1));
 

    handles.opt.Real = 1;
    
    
    

end
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_ShowImages.
function pushbutton_ShowImages_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ShowImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%if not(handles.LRi == 0)
    [D1,D2,D3,D4] = size(handles.LRi);
    axes(handles.LRimages);
    for i=1:D4
        set(handles.LR_counter,'String',i); 
        imshow(uint8(handles.LRi(:,:,:,i)*(255/max(max(max(handles.LRi(:,:,:,i)))))));
      
        pause(0.75);
    end
%end


% --- Executes on button press in pushbutton_SRG.
function pushbutton_SRG_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SRG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Mode Simluated a
mode = get(handles.popupmenu_MODE,'Value');

% Load Base Options
%% Specific to Bayesian methods

handles.opt.noise_estimate = 'SEPARATE';
handles.opt.LK_maxit = 35;
handles.opt.LK_thr = 1e-4;
handles.opt.PCG_minit = 20;
handles.opt.PCG_maxit = 100;
handles.opt.PCG_thr = 1e-10;
handles.opt.maxit = 100;%opt.maxit = 100;
handles.opt.Canal.maxit = 100;
handles.opt.thr = 1e-5;

handles.opt.InitWithAvgImg = 1;
handles.opt.InitImgExists = 0;

%% Output options
handles.opt.WriteImages = 0;
handles.opt.ShowImages = 1;
handles.opt.KeepHistory = 0;
handles.opt.verbose = 1; 
handles.opt.debug = 0;
handles.opt.interv_ShowImages = 1; % Show images each opt.interv_ShowImages iterations
 handles.opt.FixedBeta = 0;        
%----------------

if exist('handles.srimage','var')
    clear handles.srimage
end

 set(handles.text_Runing,'Visible','Off');
 set(handles.text_Runing,'Enable','Off');
 set(handles.opt.ref_cancel,'Value',0);
 set(handles.pushbutton_saveSR,'Visible','off');
set(handles.pushbutton_saveSR,'Enable','off');

        set(handles.pushbutton_BestResults,'Visible','off');
        set(handles.pushbutton_BestResults,'Enable','off');

if mode == 2
    handles.opt.Real = 0;
   
        handles.opt.KeepHistory = 0;
   
      set(handles.text_Number_iteration,'Enable','off'); 
     set(handles.text_degradation,'Enable','Off');
        set(handles.value_degradation,'Enable','Off');
        set(handles.text_degradation,'Visible','Off');
        set(handles.value_degradation,'Visible','Off');
        
    
    set(handles.popupmenu_registered,'Visible','On');
    set(handles.popupmenu_registered,'Enable','On');
    
    ADDREGNOISE = get(handles.popupmenu_registered,'Value')-1;
    handles.opt.EstimateRegistration = ADDREGNOISE;
    
    if ADDREGNOISE,
        handles.opt.sx_init = handles.opt.sx_true + sqrt(1)*randn(size(handles.opt.sx_true));
        handles.opt.sy_init = handles.opt.sy_true + sqrt(1)*randn(size(handles.opt.sy_true));
        handles.opt.theta_init = handles.opt.theta_true +...
            sqrt(0.1/180*pi)*randn(size(handles.opt.theta_true));
        handles.opt.sx_init(1) = 0; 
        handles.opt.sy_init(1) = 0;
        handles.opt.theta_init(1) = 0;
        handles.opt.InitWithAvgImg = 0;
    else
        handles.opt.sx_init = handles.opt.sx_true;
        handles.opt.sy_init = handles.opt.sy_true;
        handles.opt.theta_init = handles.opt.theta_true;
        handles.opt.InitWithAvgImg = 1;
    end
else % Real mode
     %% Activation handles.opt.KeepHistory
      
     %% Registraion
     
     set(handles.popupmenu_registered,'Visible','Off');
    set(handles.popupmenu_registered,'Enable','Off');
     set(handles.pushbutton_LRG,'Enable','Off');
     handles.opt.M =  handles.opt.m;
     
     handles.opt.N =  handles.opt.n; % For the initial registration 
    
     handles.opt.xtrue = [];
     handles.opt.method ='variational';
     handles.opt.Real = 1;
     
     handles.opt.theta_init = zeros(1, handles.opt.L);
     handles.opt.sx_init = zeros(1, handles.opt.L);
     handles.opt.sy_init = zeros(1, handles.opt.L);
     
     handles.opt.theta = zeros(1, handles.opt.L);
     handles.opt.sx = zeros(1, handles.opt.L);
     handles.opt.sy = zeros(1, handles.opt.L);
     yvecs = handles.yvecs;
     
     for kk = 2: handles.opt.L
         [newsk, Lambdak, yhatk] = LKvar(yvecs{1}, kk,yvecs{kk},0,1,1,zeros(3), 1, handles.opt);
         handles.opt.theta(kk) = newsk(1);
         handles.opt.sx(kk) = handles.opt.res * newsk(2);
         handles.opt.sy(kk) = handles.opt.res * newsk(3);
     end
    
     handles.opt.theta_init = handles.opt.theta;
     handles.opt.sx_init = handles.opt.sx;
     handles.opt.sy_init = handles.opt.sy;
     
     handles.opt.M = handles.opt.m * handles.opt.res;
     
     handles.opt.N = handles.opt.n * handles.opt.res;
     handles.opt.EstimateRegistration = 1;
     handles.opt.sigma =0.0;
     ADDREGNOISE = 0;
    %% Blurring Matrix

    o_blur = get(handles.popupmenu_Blur_HR,'Value') ;

    switch o_blur
        case 1
            handles.opt.h = 1;
        case 2
            size_h = get(handles.edit_size_h_HR,'String');
            size_h = uint8(str2num(size_h));
            if isempty(size_h)
                size_h=0;
            end
            if size_h <= 0
                warndlg({'Invalid blurring matrix size.',' Using default value '},'Invalid Value',...
                    'modal');
                set(handles.edit_size_h_HR,'String','3');
                handles.opt.h = fspecial('average');
            else
                handles.opt.h = fspecial('average',double(size_h));
            end
        case 3
            size_h = get(handles.edit_size_h_HR,'String');
            size_h = uint8(str2num(size_h));
            sgm = get(handles.edit_varh_HR,'String');
            sgm = str2num(sgm);
            if isempty(size_h)
                size_h=0;
            end
            if isempty(sgm)
                sgm = 0;
            end

            if (size_h <= 0) | (sgm <= 0)
                warndlg({'Invalid blurring matrix parameter values.',' Using default values '},'Invalid Value',...
                    'modal');
                set(handles.edit_size_h_HR,'String','3');
                set(handles.edit_varh_HR,'String','0.5');
                handles.opt.h = fspecial('gaussian');
            else
                handles.opt.h = fspecial('gaussian',double(size_h),sgm);
            end     
        case 4
            size_h = get(handles.edit_size_h_HR,'String');
            size_h = str2num(size_h);
            if isempty(size_h)
                size_h=0;
            end
            if size_h <= 0
                warndlg({'Invalid blurring matrix size.',' Using default value '},'Invalid Value',...
                    'modal');
                set(handles.edit_size_h_HR,'String','5');
                handles.opt.h = fspecial('disk');
            else
                handles.opt.h = fspecial('disk',size_h);
            end
        case 5
        
            load('tempSR/h_aux.mat');
            h =h/(sum(sum(h)));
            handles.opt.h = h;
            
         case 6
            size_h = get(handles.edit_size_h_HR,'String');
            size_h = uint8(str2num(size_h));
            if isempty(size_h)
                size_h=0;
            end
            for ib =1:handles.opt.L
            xx=reshape(handles.yvecs{ib},handles.opt.m,handles.opt.n);
            xx = imresize(xx, handles.opt.res, 'bicubic');
            
            if size_h <= 0
                warndlg({'Invalid blurring matrix size.',' Using default value '},'Invalid Value',...
                    'modal');
                set(handles.edit_size_h_HR,'String','3');
                
        
               [xx, pfs(:,:,ib)] = deconvblind(xx,ones(size_h,size_h));
               clear xx
            else
             
              [xx,  pfs(:,:,ib)] = deconvblind(xx,ones(size_h,size_h));
              clear xx
            end   
            end
            handles.opt.h = mean(pfs,3);
            h=handles.opt.h;
            save('h_deconvblind.mat','h');
        case 7
            size_h = get(handles.edit_size_h_HR,'String');
            size_h = uint8(str2num(size_h));
            if isempty(size_h)
                size_h=3;
            end
            radio = get(handles.dataRadio, 'String');
            radio = str2num(radio);
             sgm = get(handles.edit_varh_HR,'String');
            sgm = str2num(sgm);
             if isempty(sgm)
                sgm = 0;
            end

            if (size_h <= 0) | (sgm <= 0)
                warndlg({'Invalid blurring matrix parameter values.',' Using default values '},'Invalid Value',...
                    'modal');
                set(handles.edit_size_h_HR,'String','3');
                set(handles.edit_varh_HR,'String','3.5');
                handles.opt.h = fatmosfblur(3.0 ,3.5,size_h,size_h);
            else
                handles.opt.h =fatmosfblur(double(radio) ,double(sgm),size_h,size_h);
            end    
            
    end
    % h -> Blur convolution matrix 
    
    set(handles.text_trwarp,'Enable','Off');
    set(handles.popupmenu_warpresults,'Enable','Off');
    set(handles.text_estwarp,'Enable','Off');
        set(handles.uitable_estwarp,'Enable','Off');
    
    % End Real Mode
end
    method = get(handles.popupmenu_SRmet,'Value');
    
    if mode == 2 % simulation
     set(handles.text_mse,'Enable','On');
        set(handles.text_psnr,'Enable','On');

        set(handles.text_mse2,'Enable','On');
         set(handles.text_psnr2,'Enable','On');
       
    else % Real
        set(handles.text_degradation,'Enable','On');
        set(handles.value_degradation,'Enable','On');
        set(handles.value_degradationd,'Enable','On');
        set(handles.text_degradation,'Visible','On');
        set(handles.value_degradation,'Visible','On');
        set(handles.value_degradationd,'Visible','On');
        
    end
       
    if method == 1
         set(handles.text_Niteration, 'Enable','Off');
             
             
                handles.opt.cancel = 0;
                set(handles.pushbutton_Cancel,'Enable','On');
             set(handles.text_Number_iteration, 'Enable','Off');
             set(handles.text_Number_iteration, 'Visible','Off');
             set(handles.text_Niteration, 'Visible','Off');
             set(handles.pushbutton_SRG,'Visible','on');
             set(handles.pushbutton_LRG,'Enable','off');
             set(handles.pushbutton_SRG,'Enable','off');
             set(handles.pushbutton_saveSR,'Visible','off');
             set(handles.pushbutton_saveSR,'Enable','off');
    else
        % set(handles.text_Niteration, 'Enable','On');
             set(handles.text_Number_iteration, 'Enable','On');
             set(handles.text_Number_iteration, 'Visible','On');
        
              set(handles.text_Number_iteration,'String',0); 

             set(handles.text_Runing,'Visible','On');
             set(handles.text_Runing,'Enable','On');
             set(handles.text_Runing,'String','Running ...');
             
            LoadParametersSR;
            if mode == 1
                 handles.opt.KeepHistory = 1; 
            end
            handles.opt.cancel = 0;
            set(handles.pushbutton_Cancel,'Visible','On');                          
            set(handles.pushbutton_Cancel,'Enable','On');
           % pause(0.1)
           
             set(handles.pushbutton_LRG,'Enable','off');
            set(handles.pushbutton_SRG,'Enable','off');
             set(handles.pushbutton_saveSR,'Visible','off');
             set(handles.pushbutton_saveSR,'Enable','off');
        
        
    end
    handles.opt.Canal.Color = 0;
    switch method
        %% Bicubic
        case 1
            
                
            [handles.srimage.x,handles.srimage.out] = BicubicSR(handles.y,handles.opt);
            handles.srimage.xc =[];
            if handles.opt.Color
                
                for ic= 1:3
                    yc = [];
                    for iob = 1:handles.opt.L
                        aux = handles.LRi(:,:,ic,iob);
                        yc = [yc;aux(:)];
                    end
                    
                    [handles.srimage.xc(:,ic),handles.srimageColor.out] = BicubicSR(yc,handles.opt);
                   
                    clear yc
                end
            end
           
            
              
        %% solvex_var
        case 2
           
            
            FILE_log = fopen(sprintf('tempSR/LOG_VAR_TV_maxit%d_PCGmaxit%d_LKmaxit%d_sigma%g_RegERR%d.txt', handles.opt.maxit, handles.opt.PCG_maxit, handles.opt.LK_maxit, handles.opt.sigma,ADDREGNOISE),'w');
            handles.opt.LogFile = FILE_log;
            
            handles.srimage.x = [];
            [handles.srimage.x,handles.srimage.out]= solvex_var(handles.y,handles.opt,handles.HRimage,handles);    

            
            
        %% solvex_varL4
        case 3
          
            
            FILE_log = fopen(sprintf('tempSR/LOG_VAR_L4_maxit%d_PCGmaxit%d_LKmaxit%d_sigma%g_RegERR%d.txt', handles.opt.maxit, handles.opt.PCG_maxit, handles.opt.LK_maxit, handles.opt.sigma,ADDREGNOISE),'w');
            handles.opt.LogFile = FILE_log;
             handles.srimage.x = [];
          
            [handles.srimage.x,handles.srimage.out]= solvex_varL4(handles.y,handles.opt,handles.HRimage,handles); 
           
        %% solvex_varL4SAR
        case 4 
          
            FILE_log = fopen(sprintf('tempSR/LOG_VAR_SAR_maxit%d_PCGmaxit%d_LKmaxit%d_sigma%g_RegERR%d_exp1.txt', handles.opt.maxit, handles.opt.PCG_maxit, handles.opt.LK_maxit, handles.opt.sigma,ADDREGNOISE),'w');
            handles.opt.LogFile = FILE_log;
            handles.opt.lambda_prior = 0; % SAR prior is seleted; with value 1 the norm l1 prior is selected
          
            [handles.srimage.x,handles.srimage.out]= solvex_varL4SAR(handles.y,handles.opt,handles.HRimage,handles);   
                 
           
            
            
  %% solvex_varL4SAR Combination
        case 5 
            
            
            FILE_log = fopen(sprintf('tempSR/LOG_VAR_combL4SAR_maxit%d_PCGmaxit%d_LKmaxit%d_sigma%g_RegERR%d_exp1.txt', handles.opt.maxit, handles.opt.PCG_maxit, handles.opt.LK_maxit, handles.opt.sigma,ADDREGNOISE),'w');
            handles.opt.LogFile = FILE_log;
           handles.opt.lambda_prior = str2num(get(handles.edit_lambda,'string'));
             set(handles.edit_lambda,'String',num2str(handles.opt.lambda_prior));
            
            %handles.opt.lambda_prior = 0.5; % SAR prior is seleted; with value 1 the norm l1 prior is selected
           
            [handles.srimage.x,handles.srimage.out]= solvex_varL4SAR(handles.y,handles.opt,handles.HRimage,handles);   
                     
             
            
            
 %% solvex_varTVSAR Combination
        case 6 
            
            
            FILE_log = fopen(sprintf('tempSR/LOG_VAR_combTVSAR_maxit%d_PCGmaxit%d_LKmaxit%d_sigma%g_RegERR%d_exp1.txt', handles.opt.maxit, handles.opt.PCG_maxit, handles.opt.LK_maxit, handles.opt.sigma,ADDREGNOISE),'w');
            handles.opt.LogFile = FILE_log;
           handles.opt.lambda_prior = str2num(get(handles.edit_lambda,'string'));
             set(handles.edit_lambda,'String',num2str(handles.opt.lambda_prior));
            
            %handles.opt.lambda_prior = 0.5; % SAR prior is seleted; with value 1 the norm l1 prior is selected
           
            [handles.srimage.x,handles.srimage.out]= solvex_varTVSAR(handles.y,handles.opt,handles.HRimage,handles);   
           
                   
    
        %% Adds filters
        case 7            
           
            FILE_log = fopen(sprintf('tempSR/LOG_AddsFiltersDxDy_maxit%d_sigma%g_RegERR%d.txt', handles.opt.maxit, handles.opt.sigma,ADDREGNOISE),'w');
            handles.opt.LogFile = FILE_log;
          
            [handles.srimage.x,handles.srimage.out]= solvex_sumpriorSRVarPGMIX(handles.y,handles.opt,handles.HRimage,handles);
       

           %------------ 
            
             
    end
   
    if method >1 
         set(handles.opt.ref_cancel,'Value',0);
        handles.opt.cancel = 0;
        handles.srimage.xc = [];
        if handles.opt.Color
            [handles]= ColorBuilt(method,handles);

        end
    end
    
       
            set(handles.pushbutton_SRG,'Enable','on');
            set(handles.pushbutton_Cancel,'Enable','off');
             set(handles.pushbutton_Cancel,'Visible','Off');
              set(handles.pushbutton_saveSR,'Visible','on');
              set(handles.pushbutton_saveSR,'Enable','on');

             set(handles.text_Runing,'String','Completed ...');
          if method >1   
            fclose(handles.opt.LogFile);
          end
    handles.srimage.x = reshape(handles.srimage.x,[handles.opt.M,handles.opt.N]);
    axes(handles.HRimage);
     set(handles.text_Msr,'String',handles.opt.M);
        set(handles.text_Nsr,'String',handles.opt.N);
        
        if handles.opt.Color == 1
           handles.srimage.xc = reshape(handles.srimage.xc,[handles.opt.M,handles.opt.N,3]);
           
           imshow(handles.srimage.xc);
    
        else
            imshow(handles.srimage.x);
        end
    if mode == 2
        set(handles.text_mse,'Enable','On');
        set(handles.text_psnr,'Enable','On');

        set(handles.text_mse2,'Enable','On');
        set(handles.text_mse2,'String',num2str(handles.srimage.out.MSE));

        set(handles.text_psnr2,'Enable','On');
        set(handles.text_psnr2,'String',num2str(handles.srimage.out.PSNR,'%f dB'));
       
        set(handles.pushbutton_LRG,'Enable','on');
        
    else
        set(handles.pushbutton_LRG,'Enable','Off');
    end

    if mode == 2
              set(handles.text_Number_iteration,'Enable','off');  
            set(handles.text_trwarp,'Visible','Off');
            set(handles.popupmenu_warpresults,'Visible','Off');
            set(handles.text_estwarp,'Visible','Off');
            set(handles.uitable_trwarp,'Visible','Off');
                set(handles.uitable_estwarp,'Visible','Off');
        if method ~= 1
             
        set(handles.pushbutton_BestResults,'Visible','on');
        set(handles.pushbutton_BestResults,'Enable','on');
        set(handles.pushbutton_BestResults,'String','Best Results');
            
          set(handles.text_trwarp,'Visible','On');
            set(handles.popupmenu_warpresults,'Visible','On');

            set(handles.text_trwarp,'Enable','On');
              set(handles.uitable_trwarp,'Visible','On');
            set(handles.popupmenu_warpresults,'Enable','On');
            set(handles.popupmenu_warpresults,'Value',1);

            set(handles.uitable_trwarp,'Enable','On');
            set(handles.uitable_trwarp,'Data',handles.opt.sx_true);
            
            
                
            if ADDREGNOISE % && method ~=7 && method ~= 8
                
                set(handles.text_estwarp,'Visible','On');
                set(handles.uitable_estwarp,'Visible','On');

                set(handles.text_estwarp,'Enable','On');
                set(handles.uitable_estwarp,'Enable','On');
                set(handles.uitable_estwarp,'Data',handles.srimage.out.sx);  
            end
        end

    else
        if method ~= 1% & method ~= 7 & method ~= 8
                set(handles.popupmenu_warpresults,'Visible','On');

                set(handles.text_estwarp,'Visible','On');
                set(handles.uitable_estwarp,'Visible','On');
            set(handles.text_trwarp,'Enable','On');
            set(handles.popupmenu_warpresults,'Enable','On');
            set(handles.popupmenu_warpresults,'Value',1);
    
            set(handles.text_estwarp,'Enable','On');
            set(handles.uitable_estwarp,'Enable','On');
            set(handles.uitable_estwarp,'Data',handles.srimage.out.sx);   
        end
        % provide acces to itaration number
        set(handles.text_Number_iteration, 'Enable','on');
        iterationNumber = get(handles.text_Number_iteration,'String');
        handles.iterationNumber = str2num(iterationNumber);
        
    end
    
    
    
    
%% Mode Real


    
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton_LRG.
function pushbutton_LRG_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LRG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.opt.LR_exe == 1
       
    choice = questdlg('The low resolution images were not saved:', ...
	'Warning','Continue','Cancel','Cancel');
    % Handle response
    if strcmp(choice,'Cancel')
        return
    end
    
else
    handles.opt.LR_exe = 1;
end

%% --- The original image is obtained egain.
handles.opt.xtrue = handles.opt.HRi(:);
[handles.opt.M,handles.opt.N]=size(handles.opt.HRi);

%% Number of Frames
nlr = get(handles.edit_NLR,'String');
nlr = uint8(str2num(nlr));
set(handles.edit_NLR,'String',nlr);
if isempty(nlr)
    nlr=0;
end
if not(nlr > 0 & nlr <= 50) 
    warndlg({'Invalid number of frames.',' Using 4 '},'Invalid Value',...
        'modal');
    set(handles.edit_NLR,'String','4');
    nlr=4;
end

handles.opt.L = double(nlr);

%% Magnification Factor
MF = get(handles.edit_Magnification,'String');
MF = uint8(str2num(MF));
set(handles.edit_Magnification,'String',MF);
if isempty(MF)
    MF=0;
end

if (MF ~= 2) & (MF ~= 4)
 warndlg({'Invalid magnification factor value. Valid values are 2 and 4',' Using 2 '},'Invalid Value',...
     'modal');
    set(handles.edit_Magnification,'String','2');    
    MF=2;
 end
handles.opt.res = double(MF);

%% LR dimensions
handles.opt.m = double(round(handles.opt.M / handles.opt.res));
handles.opt.n = double(round(handles.opt.N / handles.opt.res));

%% Noise
noise = get(handles.edit_Noise,'String');
varosnr = get(handles.radiobutton_var,'Value');

if varosnr ==1
    noise_var = str2num(noise);
    if not(noise_var > 0)
        noise_var = [];
    end
else
    snr = str2num(noise);
    if isempty(snr) 
        warndlg({'Invalid noise SNR value.',' Using 30 dB '},'Invalid Value',...
            'modal');
        set(handles.edit_Noise,'String','1');    
        snr = 30;
    end
    aux = handles.opt.xtrue;
    noise_var = std2(aux)/(10^(snr/20));
         
end

if isempty(noise_var) 
    warndlg({'Invalid noise variance value.',' Using 1 '},'Invalid Value',...
        'modal');
    set(handles.edit_Noise,'String','1');    
    noise_var = 1;
end

handles.opt.sigma = noise_var;

%% Blurring Matrix

o_blur = get(handles.popupmenu_Blur,'Value') ;

switch o_blur
    case 1
        handles.opt.h = 1;
    case 2
        size_h = get(handles.edit_size_h,'String');
        size_h = uint8(str2num(size_h));
        if isempty(size_h)
            size_h=0;
        end
        if size_h <= 0
            warndlg({'Invalid blurring matrix size.',' Using default value'},'Invalid Value',...
                'modal');
            set(handles.edit_size_h,'String','3');
            handles.opt.h = fspecial('average');
        else
            handles.opt.h = fspecial('average',double(size_h));
        end
    case 3
        size_h = get(handles.edit_size_h,'String');
        size_h = uint8(str2num(size_h));
        sgm = get(handles.edit_varh,'String');
        sgm = str2num(sgm);
        if isempty(size_h)
            size_h=0;
        end
        if isempty(sgm)
            sgm = 0;
        end
        
        if (size_h <= 0) | (sgm <= 0)
            warndlg({'Invalid blurring matrix parameter values.',' Using default values '},'Invalid Value',...
                'modal');
            set(handles.edit_size_h,'String','3');
            set(handles.edit_varh,'String','0.5');
            handles.opt.h = fspecial('gaussian');
        else
            handles.opt.h = fspecial('gaussian',double(size_h),sgm);
        end     
    case 4
        size_h = get(handles.edit_size_h,'String');
        size_h = str2num(size_h);
        if isempty(size_h)
            size_h=0;
        end
        if size_h <= 0
            warndlg({'Invalid blurring matrix size.',' Using default value '},...
                'Invalid Value','modal');
            set(handles.edit_size_h,'String','5');
            handles.opt.h = fspecial('disk');
        else
            handles.opt.h = fspecial('disk',size_h);
        end
    case 5
        
        load('tempSR/h_aux.mat');
        if sum(sum(h))~=0
           h =h/(sum(sum(h)));
        end
        handles.opt.h = h;
end
%% Warp

warpmod = get(handles.popupmenu_Warp,'Value');
nlr = handles.opt.L;

if warpmod == 1
    handles.opt.sx_true = 10*rand(1,nlr)-10*rand(1,nlr);
    handles.opt.sy_true = 10*rand(1,nlr)-10*rand(1,nlr);
    handles.opt.theta_true_grad = (sqrt(60)*rand(1,nlr)-sqrt(60)*rand(1,nlr));
    handles.opt.sx_true(1) = 0;
    handles.opt.sy_true(1) = 0;
    handles.opt.theta_true_grad(1) = 0;    
    feat = get(handles.popupmenu_feat,'Value');
    
    switch feat
        case 1
            set(handles.uitable_warp,'Data',handles.opt.sx_true);
        case 2
            set(handles.uitable_warp,'Data',handles.opt.sy_true);
        case 3
            set(handles.uitable_warp,'Data',handles.opt.theta_true_grad);
    end
    
else
    comp = [ length(handles.opt.sx_true) length(handles.opt.sy_true) length(handles.opt.theta_true_grad)];
    if not(all(nlr == comp))
        warndlg({'Invalid warping values.',' Using random values'},'Invalid Value','modal');
        handles.opt.sx_true = 10*rand(1,nlr)-10*rand(1,nlr);%4*rand(1,nlr)-2;
        handles.opt.sy_true = 10*rand(1,nlr)-10*rand(1,nlr);%4*rand(1,nlr)-2;
        handles.opt.theta_true_grad = (sqrt(60)*rand(1,nlr)-sqrt(60)*rand(1,nlr));%(20*rand(1,nlr)-10);
         handles.opt.sx_true(1) = 0;
        handles.opt.sy_true(1) = 0;
        handles.opt.theta_true_grad(1) = 0;  
    end
end
%% Call to Create_Data
handles.opt.theta_true = handles.opt.theta_true_grad/180*pi;
handles.opt.xtrue = im2double(handles.opt.xtrue);

%%--- Frame of real image  
HRi=double(handles.opt.xtrue);

fac = double(handles.opt.res);

nf = double(handles.opt.M);
nc = double(handles.opt.N);

marin=2;
maren=nf+marin-floor((nf+marin)/fac)*fac;
marin=marin+maren;
dpar = abs( floor(((2*double(marin)+nc)/fac)/fac)*fac-floor((2*double(marin)+nc)/fac ));
marin = marin + dpar;
marin = (round((nf+2*marin)/fac)*fac -nf)/2; % size multiple of fac
HRi=padarray(reshape(HRi,nf,nc),double([marin marin]),max(HRi)/2);

%----Color ----
if handles.opt.Color == 1
    HRiColor1(:,:) = handles.opt.HRiColor(:,:,1);
     HRiColor2(:,:) = handles.opt.HRiColor(:,:,2);
      HRiColor3(:,:) = handles.opt.HRiColor(:,:,3);
     HRiColor(:,:,1)=padarray(reshape(HRiColor1,nf,nc),double([marin marin]),max(max(HRiColor1))/2); 
     HRiColor(:,:,2)=padarray(reshape(HRiColor2,nf,nc),double([marin marin]),max(max(HRiColor2))/2); 
     HRiColor(:,:,3)=padarray(reshape(HRiColor3,nf,nc),double([marin marin]),max(max(HRiColor3))/2);
     handles.opt.xtrueColor = HRiColor;
     handles.opt.HRiColor = HRiColor;
     clear   HRiColor1 HRiColor2 HRiColor3 
end
[nf,nc]=size(HRi);
handles.opt.M=nf;
handles.opt.N=nc;

handles.opt.xtrue =HRi(:);%reshape( HRi/max(HRi(:)),nf*nc,1);

axes(handles.HRimage_SM);
 
    if handles.opt.Color == 1
        imshow(HRiColor);
    else
        imshow(HRi);
    end
    set(handles.nfHRsimuled,'String',nf);
  set(handles.ncHRsimuled,'String',nc);

%% LR dimensions
handles.opt.m = double(round(handles.opt.M / double(handles.opt.res)));
handles.opt.n = double(round(handles.opt.N / double(handles.opt.res)));
clear HRiColor

%%--- End frame


opt = handles.opt;
save('tempSR/opttemp.mat','opt');
[y,W] = create_data(opt);
handles.y = y;
npix = handles.opt.n*handles.opt.m;
handles.opt.xtrue = handles.opt.xtrue/max(handles.opt.xtrue(:));

if handles.opt.Color == 1
    optC = opt;
    HRiColorC(:,:) = opt.HRiColor(:,:,1);
    optC.xtrue = double(HRiColorC(:));
   [y1,W] = create_data(optC);
   clear W
      HRiColorC(:,:) = opt.HRiColor(:,:,2);
      optC.xtrue = double(HRiColorC(:));
   [y2,W] = create_data(optC);
   clear W
     HRiColorC(:,:) = opt.HRiColor(:,:,3);
     optC.xtrue = double(HRiColorC(:));
   [y3,W] = create_data(optC);
   clear W optC HRiColorC
    for i=1:handles.opt.L
        aux = y1((i-1)*npix+1:i*npix);
        LRi(:,:,1,i) = reshape(aux,[handles.opt.m,handles.opt.n]);
        
         aux = y2((i-1)*npix+1:i*npix);
        LRi(:,:,2,i) = reshape(aux,[handles.opt.m,handles.opt.n]);
         aux = y3((i-1)*npix+1:i*npix);
        LRi(:,:,3,i) = reshape(aux,[handles.opt.m,handles.opt.n]);
    end
    
else
    for i=1:handles.opt.L
        aux = y((i-1)*npix+1:i*npix);
        LRi(:,:,:,i) = reshape(aux,[handles.opt.m,handles.opt.n]);
    end
end

handles.LRi = LRi;

%% Show images

axes(handles.HRimage_SM);
%imshow((HRi));
set(handles.text_Mlr,'String',handles.opt.m);
set(handles.text_Nlr,'String',handles.opt.n);
if handles.opt.Color
    imshow(uint8(handles.opt.HRiColor*(256/(max(max(max(handles.opt.HRiColor)))))));
else
    imshow(uint8(HRi*(255/max(max(HRi)))));
end


if not(handles.LRi == 0)
    [D1,D2,D3,D4] = size(handles.LRi);
    axes(handles.LRimages);
    for i=1:D4    
        
        imshow(uint8(handles.LRi(:,:,:,i)*(255/max(max(max(handles.LRi(:,:,:,i)))))));
        set(handles.LR_counter,'String',i);
        pause(0.75);
    end
end


set(handles.ref_img,'Enable','On');
set(handles.pushbutton_Save_LRI,'Enable','On');
set(handles.pushbutton_ShowImages,'Enable','On');

%% Enable SR panel
set(handles.pushbutton_SRG,'Enable','On');
set(handles.popupmenu_SRmet,'Enable','On');
set(handles.popupmenu_registered,'Enable','On');
set(handles.popupmenu_registered,'Visible','On');

set(handles.edit_MFSR,'String',num2str(handles.opt.res));
set(handles.ref_img, 'String',num2str(1));

%% Save Datas
handles.output = hObject;
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu_MODE.
function popupmenu_MODE_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_MODE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.LRi = 0;
handles.opt.cancel =0; 

handles.opt.ref_cancel = libpointer('doublePtr',handles.opt.cancel);
set(handles.opt.ref_cancel,'Value',0);
get(gcbo,'Value');

cla(handles.LRimages);
cla(handles.HRimage_SM);
cla(handles.HRimage);

set(handles.popupmenu_registered,'Visible','Off');

set(handles.pushbutton_Save_LRI,'Enable','Off');
set(handles.pushbutton_ShowImages,'Enable','Off');
set(handles.pushbutton_LRG,'Enable','Off');
set(handles.text_LRI,'Enable','On');
set(handles.text_mse,'Enable','Off');
set(handles.text_mse2,'Enable','Off');
set(handles.text_mse2,'String','0');
set(handles.text_psnr,'Enable','Off');
set(handles.text_psnr2,'Enable','Off');
set(handles.text_psnr2,'String','0 dB');
set(handles.text_trwarp,'Enable','Off');
set(handles.popupmenu_warpresults,'Enable','Off');
set(handles.popupmenu_warpresults,'Value',1);
set(handles.uitable_trwarp,'Enable','Off');
set(handles.uitable_trwarp,'Data',zeros(1,4));
set(handles.text_trwarp,'Visible','off');
set(handles.uitable_trwarp,'Visible','off');
set(handles.pushbutton_BestResults,'Visible','off');
set(handles.popupmenu_warpresults,'Visible','off');

set(handles.text_estwarp,'Enable','Off');
set(handles.uitable_estwarp,'Enable','Off');
set(handles.uitable_estwarp,'Data',zeros(1,4));
set(handles.pushbutton_SRG,'Enable','Off');
set(handles.text_Number_iteration, 'Visible','Off');
set(handles.text_Niteration, 'Visible','Off');
set(handles.pushbutton_saveSR,'Visible','off');
set(handles.pushbutton_saveSR,'Enable','off');
 set(handles.text_Runing,'Visible','Off');
 set(handles.text_Runing,'Enable','Off');
% set(handles.text_Runing,'String','Running ...');

set(handles.text_NLR,'Enable','Off');
set(handles.edit_NLR,'Enable','Off');
set(handles.edit_NLR,'String','4');
set(handles.text_Magnification_Factor,'Enable','Off');
set(handles.edit_Magnification,'Enable','Off');
set(handles.edit_Magnification,'String','2');
set(handles.popupmenu_Blur,'Enable','Off');
set(handles.popupmenu_Warp,'Enable','Off');
set(handles.popupmenu_Blur,'Value',1);
h = zeros(9); h(3,3)=1;
handles.opt.h=h;
save('tempSR/h_aux.mat','h');
set(handles.popupmenu_Warp,'Value',1);
set(handles.popupmenu_feat,'Enable','Off');
set(handles.popupmenu_feat,'Value',1);

set(handles.radiobutton_var,'Enable','Off');
set(handles.radiobutton_SNR,'Enable','Off');
set(handles.edit_Noise,'Enable','Off');
set(handles.edit_Noise,'String','');
set(handles.uitable_warp,'Enable','Off');
set(handles.uitable_warp,'Data',zeros(1,4));
set(handles.uitable_warp,'ColumnEditable',logical(zeros(1,4)));
set(handles.text_size_h,'Visible','Off');
set(handles.edit_size_h,'Visible','Off');
set(handles.edit_size_h,'String','');
set(handles.text_varh,'Visible','Off');
set(handles.edit_varh,'Visible','Off');
set(handles.edit_varh,'String','');
set(handles.uitable_estwarp,'Visible','off');
set(handles.text_estwarp,'Visible','off');
set(handles.popupmenu_warpresults,'Visible','off');

 set(handles.text_size_h_HR,'Visible','Off');
        set(handles.edit_size_h_HR,'Visible','Off');
        set(handles.text_varh_HR,'Visible','Off');
        set(handles.edit_varh_HR,'Visible','Off');
         set(handles.popupmenu_Blur_HR, 'Enable','off');

        set(handles.popupmenu_Blur_HR, 'Visible','off');

set(handles.LR_counter,'String','0');

 set(handles.text_degradation,'Enable','Off');
        set(handles.value_degradation,'Enable','Off');
        set(handles.text_degradation,'Visible','Off');
        set(handles.value_degradation,'Visible','Off');
  
  set(handles.sizeHRsimuled,'Visible','Off');
   set(handles.nfHRsimuled,'Visible','Off');
   set(handles.ncHRsimuled,'Visible','Off');       



handles.opt.Color = 0;
mode = get(gcbo,'Value');
handles.mode = mode;
if mode == 1
    set(handles.pushbutton_OLRI,'Enable','On');
    set(handles.pushbutton_OHRI_SM,'Enable','Off');
    set(handles.pushbutton_Save_LRI,'String','End');
    handles.opt.Real = 1;
   
     set(handles.text_LRI,'String','Number of Observations:');
     set(handles.LR_counter,'String','1');
     handles.n_ob = 1;
     handles.opt.L = 0;
 
    set(handles.edit_MFSR,'Enable','on');
    set(handles.pushbutton_LRG,'Enable','Off');
    handles.opt.Open_Real= 0;
   
else
    set(handles.pushbutton_OLRI,'Enable','Off');
    set(handles.pushbutton_OHRI_SM,'Enable','On');
    set(handles.pushbutton_Save_LRI,'String','Save');
 
    set(handles.text_LRI,'String','Low Resolution Images:');

    set(handles.edit_MFSR,'Enable','off');
    handles.opt.Real = 0;
    
end

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_Blur.
function popupmenu_Blur_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Blur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_Blur contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Blur
filter = get(gcbo,'Value');

switch filter
    case 1 
        set(handles.text_size_h,'Visible','Off');
        set(handles.edit_size_h,'Visible','Off');
        set(handles.text_varh,'Visible','Off');
        set(handles.edit_varh,'Visible','Off');
    case 2
        set(handles.text_size_h,'Visible','On');
        set(handles.edit_size_h,'Visible','On');
        set(handles.text_varh,'Visible','Off');
        set(handles.edit_varh,'Visible','Off');
        set(handles.text_size_h,'String','Mask size (odd #):');
    case 3
        set(handles.text_size_h,'Visible','On');
        set(handles.edit_size_h,'Visible','On');
        set(handles.text_varh,'Visible','On');
        set(handles.edit_varh,'Visible','On');
        set(handles.text_size_h,'String','Mask size (odd #):');
    case 4
        set(handles.text_size_h,'Visible','On');
        set(handles.edit_size_h,'Visible','On');
        set(handles.text_varh,'Visible','Off');
        set(handles.edit_varh,'Visible','Off');
        set(handles.text_size_h,'String','Radius:');
    case 5
        set(handles.text_size_h,'Visible','Off');
        set(handles.edit_size_h,'Visible','Off');
        set(handles.text_varh,'Visible','Off');
        set(handles.edit_varh,'Visible','Off');
         MatrixReader;
        
        
end
if handles.mode == 2
    set(handles.pushbutton_LRG,'Enable','On');
end
handles.output = hObject;
guidata(hObject, handles);
        

function edit_NLR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NLR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NLR as text
%        str2double(get(hObject,'String')) returns contents of edit_NLR as a double
nlr = get(handles.edit_NLR,'String');
nlr = str2num(nlr);

handles.opt.sx_true = zeros(1,nlr);
handles.opt.sy_true = zeros(1,nlr);
handles.opt.theta_true_grad = zeros(1,nlr);

if isempty(nlr)
    nlr = 4;
end

set(handles.uitable_warp,'Data',zeros(1,nlr));
set(handles.uitable_warp,'ColumnWidth',num2cell(40*ones(1,nlr)));
set(handles.uitable_trwarp,'Data',zeros(1,nlr));
set(handles.uitable_estwarp,'Data',zeros(1,nlr));
set(handles.uitable_trwarp,'ColumnWidth',num2cell(40*ones(1,nlr)));
set(handles.uitable_estwarp,'ColumnWidth',num2cell(40*ones(1,nlr)));

ind = get(handles.popupmenu_Warp,'Value');

if ind == 1
    set(handles.uitable_warp,'ColumnEditable',logical(zeros(1,nlr)));
else
    set(handles.uitable_warp,'ColumnEditable',logical(ones(1,nlr)));
end
%set(handles.edit_NR,
handles.opt.L = nlr;
handles.output = hObject;
guidata(hObject, handles);
    
% --- Executes on selection change in popupmenu_Warp.
function popupmenu_Warp_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Warp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_Warp contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Warp
warp = get(gcbo,'Value');

data = get(handles.uitable_warp,'Data'); % value adopted in desing step

if warp == 1
    
    set(handles.uitable_warp,'ColumnEditable',logical(zeros(1,length(data))));
    handle.opt.menu_warp = 1;
      set(handles.text_NLR,'Enable','On');
     set(handles.edit_NLR,'Enable','On');
    set(handles.text_Magnification_Factor,'Enable','On');
    set(handles.edit_Magnification,'Enable','On');
    
    set(handles.popupmenu_feat,'Enable','Off');
    set(handles.uitable_warp,'Enable','Off');
  
    
elseif warp == 2
      set(handles.text_NLR,'Enable','On');
     set(handles.edit_NLR,'Enable','On');
    set(handles.text_Magnification_Factor,'Enable','On');
    set(handles.edit_Magnification,'Enable','On');
    set(handles.uitable_warp,'Enable','On');
    set(handles.popupmenu_feat,'Enable','On');
     set(handles.edit_NLR, 'Enable','On');
    set(handles.uitable_warp,'ColumnEditable',logical(ones(1,length(data))));
    handle.opt.menu_warp = 2;
else
     set(handles.uitable_warp,'Enable','Off');
     set(handles.edit_NLR, 'Enable','Off');
     handle.opt.menu_warp = 3;
    if handles.opt.res == 2
        handles.opt.L = 5;
        nlr=num2str(handles.opt.L);
      
        set(handles.edit_NLR,'String',nlr);
        set(handles.edit_NLR,'Enable','Off');
        handles.opt.sx_true = [0  0  0.5 1 0]; 
        handles.opt.sy_true = [0 0.5  0  0 1];
   
        handles.opt.theta_true = [0 3 -3 5 -5]/180*pi;
        handles.opt.theta_true_grad = [0 3 -3 5 -5];
         
    
        
    else
        handles.opt.L=17;
          nlr=num2str(handles.opt.L);
     
        set(handles.edit_NLR,'String',nlr);
        set(handles.edit_NLR,'Enable','Off');
        handles.opt.sx_true = [0  0  0.5 1 0 2.5 -1.2 0.6 -0.8 2.5 1.7 2.1 -1.2 +3.4 -1.0 -3.0 2.5]; 
        handles.opt.sy_true = [0 0.5  0  0 1 0.1 1.9  0.8  2.1  -0.1 -2.8 1.4 0.3 2.4 2.0 1.0 1.0];
        
        handles.opt.theta_true = [0 3 -3 5 -5 3.5 6.2 2.6 -4.5 -3.4 -1.3 -4.2 3.5 4.6 2.0 -4.0 5.0]/180*pi;
        handles.opt.theta_true_grad = [0 3 -3 5 -5 3.5 6.2 2.6 -4.5 -3.4 -1.3 -4.2 3.5 4.6 2.0 -4.0 5.0];
       
    end
    
end

set(handles.popupmenu_Blur,'Enable','On');
     set(handles.popupmenu_Warp,'Enable','On');
  set(handles.radiobutton_var,'Enable','On');
    set(handles.radiobutton_SNR,'Enable','On');    
    set(handles.edit_Noise,'Enable','On');
set(handles.pushbutton_LRG,'Enable','On');
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_feat.
function popupmenu_feat_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_feat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_feat contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_feat
feat = get(handles.popupmenu_feat,'Value');

switch feat
    case 1
        set(handles.uitable_warp,'Data',handles.opt.sx_true);
    case 2
        set(handles.uitable_warp,'Data',handles.opt.sy_true);
    case 3
        set(handles.uitable_warp,'Data',handles.opt.theta_true_grad);
end
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete('tempSR/h_aux.mat');


% --- Executes when entered data in editable cell(s) in uitable_warp.
function uitable_warp_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_warp (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
menu_Warp =get(handles.popupmenu_Warp, 'Value');
if menu_Warp ~= 3
    feat = get(handles.popupmenu_feat,'Value');
    aux = get(handles.uitable_warp,'Data');
    switch feat
        case 1
            handles.opt.sx_true = aux;
        case 2
            handles.opt.sy_true = aux;
        case 3
            handles.opt.theta_true_grad = aux;
    end

    handles.opt.sx_true(1)=0;
    handles.opt.sy_true(1)=0;
    handles.opt.theta_true_grad(1)=0;
end
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_SRmet.
function popupmenu_SRmet_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_SRmet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_SRmet contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_SRmet

set(handles.filterUsed,'Enable','off', 'Visible','off');

method = get(handles.popupmenu_SRmet,'Value');

            set(handles.text_trwarp,'Visible','Off');
            set(handles.popupmenu_warpresults,'Visible','Off');
            set(handles.text_estwarp,'Visible','Off');
            set(handles.uitable_trwarp,'Visible','Off');
                set(handles.uitable_estwarp,'Visible','Off');
    
if method ~= 5 | method ~= 6
            set(handles.text_lambda,'Visible','off');
            set(handles.text_lambda,'Enable','off');
             set(handles.edit_lambda,'Visible','off');
            set(handles.edit_lambda,'Enable','off');
end

mode = get(handles.popupmenu_MODE,'Value');
if mode == 1
    set(handles.edit_MFSR,'Enable','On');
else
    set(handles.edit_MFSR,'String',num2str(handles.opt.res));
    set(handles.edit_MFSR,'Enable','Off');
end

switch method
%% Bicubic
case 1
 
%% solvex_var
case 2
  
%% solvex_varL4
case 3    
   
              
%% solvex_varL4SAR
case 4 
  
              
%% solvex_varL4SAR combination
case 5 
         
    set(handles.text_lambda,'Visible','on');
    set(handles.text_lambda,'Enable','on');
     set(handles.edit_lambda,'Visible','on');
    set(handles.edit_lambda,'Enable','on');
%% solvex_varTVSAR combination
case 6 
      
    set(handles.text_lambda,'Visible','on');
    set(handles.text_lambda,'Enable','on');
     set(handles.edit_lambda,'Visible','on');
    set(handles.edit_lambda,'Enable','on');    
    

   
case 7
    % Mix Filters prior
    FilterManagement;
   waitfor(FilterManagement);
    load('tempSR/Filter.mat','F','filternames');
    delete('tempSR/Filter.mat');
    handles.f = F;
    handles.filternames = filternames;
    salfilter = 'Filter Used: ';
    for i = 1: size(filternames,2)
        if i == 1
            salfilter = [salfilter filternames{i}];
        else
            salfilter = [salfilter ' + ' filternames{i}];
        end
    end
          
            
    set(handles.filterUsed,'Enable','on');
    set(handles.filterUsed,'String',salfilter,'Visible','on');
    
end  
handles.output = hObject;
guidata(hObject, handles);


function edit_MFSR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MFSR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MFSR as text
%        str2double(get(hObject,'String')) returns contents of edit_MFSR as a double
MFSR = get(handles.edit_MFSR,'String');
MFSR = round(abs(str2num(MFSR)));

if (isempty(MFSR) | MFSR == 0) | (MFSR ~= 2 & MFSR ~= 4)
    MFSR = 2;
end

set(handles.edit_MFSR,'String',num2str(MFSR));
handles.opt.res = double(MFSR);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_warpresults.
function popupmenu_warpresults_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_warpresults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_warpresults contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_warpresults
feat = get(gcbo,'Value');

switch feat
    case 1
        set(handles.uitable_trwarp,'Data',handles.opt.sx_true);
        set(handles.uitable_estwarp,'Data',handles.srimage.out.sx);
    case 2
        set(handles.uitable_trwarp,'Data',handles.opt.sy_true);
        set(handles.uitable_estwarp,'Data',handles.srimage.out.sy);
    case 3
        set(handles.uitable_trwarp,'Data',handles.opt.theta_true_grad);
        set(handles.uitable_estwarp,'Data',(handles.srimage.out.theta)*180/pi);
end
handles.output = hObject;
guidata(hObject, handles);



function edit_Magnification_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Magnification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Magnification as text
%        str2double(get(hObject,'String')) returns contents of edit_Magnification as a double


MFSR = get(handles.edit_Magnification,'String');
MFSR = round(abs(str2num(MFSR)));

% if isempty(MFSR) | MFSR == 0
%     MFSR = 2;
% end
if MFSR == 2 || MFSR ==4
    
    set(handles.edit_MFSR,'String',num2str(MFSR));
else
    MFSR = 2;
    set(handles.edit_MFSR,'String',num2str(MFSR));
end
handles.opt.res = MFSR;


handles.output = hObject;
guidata(hObject, handles);



% --- Executes when selected cell(s) is changed in uitable_warp.
function uitable_warp_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_warp (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_Noise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Noise as text
%        str2double(get(hObject,'String')) returns contents of edit_Noise as a double


noise = get(handles.edit_Magnification,'String');
noise = round(abs(str2num(noise)));
handles.opt.SNR = noise;
set(handles.pushbutton_LRG,'Enable','On');
handles.output = hObject;
guidata(hObject, handles);



function edit_size_h_Callback(hObject, eventdata, handles)
% hObject    handle to edit_size_h (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_size_h as text
%        str2double(get(hObject,'String')) returns contents of edit_size_h as a double
h_size = get(handles.edit_size_h,'String');
h_size = round(abs(str2num(h_size)));
if h_size - floor(h_size/2)*2 == 0,
    h_size = h_size +1;
    set(handles.edit_size_h,'String',num2str(h_size));

end
handles.output = hObject;
guidata(hObject, handles);

    





function edit_varh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_varh as text
%        str2double(get(hObject,'String')) returns contents of edit_varh as a double



function edit_Niteration_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Niteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Niteration as text
%        str2double(get(hObject,'String')) returns contents of edit_Niteration as a double
% set(handles.edit_Niteration,'String',num2str());
% 
% handles.output = hObject;
% guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_Niteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Niteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text_Niteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Niteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function LR_counter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LR_counter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text_Number_iteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Number_iteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function ref_img_Callback(hObject, eventdata, handles)
% hObject    handle to ref_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ref_img as text
%        str2double(get(hObject,'String')) returns contents of ref_img as a double


% --- Executes during object creation, after setting all properties.
function text_LRI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_LRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over text_LRI.
function text_LRI_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to text_LRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function text_LRI_Callback(hObject, eventdata, handles)
% hObject    handle to text_LRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_LRI as text
%        str2double(get(hObject,'String')) returns contents of text_LRI as
%        a doubl


% --- Executes on selection change in popupmenu_registered.
function popupmenu_registered_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_registered (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_registered contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_registered


% --- Executes on button press in pushbutton_Cancel.
function pushbutton_Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.opt.cancel = 1;
set(handles.opt.ref_cancel,'Value',1);
set(handles.pushbutton_Cancel,'Enable','Off');
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uipanel_Estimated_Parameters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel_Estimated_Parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_saveSR.
function pushbutton_saveSR_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_saveSR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mode = get(handles.popupmenu_MODE,'Value');
 method = get(handles.popupmenu_SRmet,'Value');
[f_name,n_route,index]=uiputfile('*.png','Save LR images...');
 if index == 1
        if handles.LRi == 0
            fprintf('No images loaded');
        else
            handles.opt.LR_exe = 0;
            [D1,D2,D3,D4]=size(handles.LRi);

            if all(ismember('.png',f_name))
                [r_f_name,c_f_name]=size(f_name);
                f_name = f_name(:,1:c_f_name-4);
            end
            M=handles.opt.M;
            
            imwrite(handles.srimage.x,[n_route f_name '.png'],'png');
            if handles.opt.Color 
                imwrite(handles.srimage.xc,[n_route f_name 'Color.png'],'png');
                imwrite(fusionarColor(handles.srimage.x,handles.srimage.xc),...
                    [n_route f_name 'ColorFusion.png'],'png');
            end
            if mode == 2 && method > 1
                if handles.opt.Color
                    imwrite(handles.srimageC.xcBest,[n_route f_name 'ColorBest.png'],'png');
                else
                    imwrite(handles.srimage.out.maxPSNR_x,[n_route f_name 'Best.png'],'png');
                end
                
            end
            outopt=handles.srimage.out;
            save([n_route f_name '_Dat'],'outopt');
            clear outopt

        end
 end



function edit_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_lambda as text
%        str2double(get(hObject,'String')) returns contents of edit_lambda as a double

lambda_prior = get(handles.edit_lambda,'String');
handles.opt.lambda_prior = str2num(lambda_prior);
if handles.opt.lambda_prior > 1.0 
    handles.opt.lambda_prior = 1.0;
    
elseif handles.opt.lambda_prior < 0.0 
    handles.opt.lambda_prior = 0.0;
end
    set(handles.edit_lambda,'String',num2str(handles.opt.lambda_prior));
handles.output = hObject;
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function edit_lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_BestResults.
function pushbutton_BestResults_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_BestResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

it = handles.srimage.out.maxPSNR_it;

boton = get(handles.pushbutton_BestResults,'String');
if boton == 'Best Results',
   set(handles.pushbutton_BestResults,'String','Last Results');
   set(handles.text_mse2,'String',num2str(handles.srimage.out.MSEs(it)));
    set(handles.text_psnr2,'String',num2str(handles.srimage.out.maxPSNR,'%f dB'));
    set(handles.text_Number_iteration,'String', num2str(handles.srimage.out.maxPSNR_it));
     axes(handles.HRimage);
     if handles.opt.Color
         imshow(reshape(handles.srimageC.xcBest,handles.opt.M,handles.opt.N,3));
     else
        imshow(handles.srimage.out.maxPSNR_x);
     end
else
    set(handles.pushbutton_BestResults,'String','Best Results');
    set(handles.text_mse2,'String',num2str(handles.srimage.out.MSEs(end)));
    set(handles.text_psnr2,'String',num2str(handles.srimage.out.PSNR,'%f dB'));
    axes(handles.HRimage);
    if handles.opt.Color
        imshow(handles.srimage.xc);
    else
        imshow(handles.srimage.x);
    end
    set(handles.text_Number_iteration,'String', num2str(handles.srimage.out.it));
end



handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pushbutton_SRG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_SRG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popupmenu_Blur_HR.
function popupmenu_Blur_HR_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Blur_HR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Blur_HR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Blur_HR

filter = get(gcbo,'Value');

 h_size = get(handles.edit_size_h_HR,'String');

if isempty(h_size) 
     set(handles.edit_size_h_HR,'String','3');
end
 
 size_v = get(handles.edit_varh_HR,'String');
 %size_v = str2num(size_h);
if isempty(size_v) 
     set(handles.edit_varh_HR,'String','1');
 end

switch filter
    case 1 
        set(handles.text_size_h_HR,'Visible','Off');
        set(handles.edit_size_h_HR,'Visible','Off');
        set(handles.text_varh_HR,'Visible','Off');
        set(handles.edit_varh_HR,'Visible','Off');
        set(handles.Radio,'Enable','off','Visible','off');
        set(handles.dataRadio,'Enable','off','Visible','off');
        handles.opt.h = 1;
    case 2
        set(handles.text_size_h_HR,'Visible','On');
        set(handles.edit_size_h_HR,'Visible','On');
        set(handles.text_varh_HR,'Visible','Off');
        set(handles.edit_varh_HR,'Visible','Off');
        set(handles.text_size_h_HR,'String','Mask size (odd #):');
         set(handles.Radio,'Enable','off','Visible','off');
         set(handles.dataRadio,'Enable','off','Visible','off');
        
        h_size = round(abs(str2num(h_size)));
        if h_size - floor(h_size/2)*2 == 0,
            h_size = h_size +1;
            set(handles.edit_size_h_HR,'String',num2str(h_size));

        end

    case 3
        set(handles.text_size_h_HR,'Visible','On');
        set(handles.edit_size_h_HR,'Visible','On');
        set(handles.text_varh_HR,'Visible','On','String','Variance');
        set(handles.edit_varh_HR,'Visible','On');
        set(handles.text_size_h_HR,'String','Mask size (odd #):');
         set(handles.Radio,'Enable','off','Visible','off');
         set(handles.dataRadio,'Enable','off','Visible','off');
        h_size = round(abs(str2num(h_size)));
        if h_size - floor(h_size/2)*2 == 0,
            h_size = h_size +1;
            set(handles.edit_size_h_HR,'String',num2str(h_size));

        end
   
    case 4
        set(handles.text_size_h_HR,'Visible','On');
        set(handles.edit_size_h_HR,'Visible','On');
        set(handles.text_varh_HR,'Visible','Off');
        set(handles.edit_varh_HR,'Visible','Off');
        set(handles.text_size_h_HR,'String','Radius:');
         set(handles.Radio,'Enable','off','Visible','off');
         set(handles.dataRadio,'Enable','off','Visible','off');

    case 5
        set(handles.text_size_h_HR,'Visible','Off');
        set(handles.edit_size_h_HR,'Visible','Off');
        set(handles.text_varh_HR,'Visible','Off');
        set(handles.edit_varh_HR,'Visible','Off');
         set(handles.Radio,'Enable','off','Visible','off');
         set(handles.dataRadio,'Enable','off','Visible','off');
        MatrixReader;

    case 6 %  desconvolution 
        set(handles.text_size_h_HR,'Visible','On');
        set(handles.edit_size_h_HR,'Visible','On');
        set(handles.text_varh_HR,'Visible','Off');
        set(handles.edit_varh_HR,'Visible','Off');
        set(handles.text_size_h_HR,'String','Mask size (odd #):');
         set(handles.Radio,'Enable','off','Visible','off');
         set(handles.dataRadio,'Enable','off','Visible','off');
        
    case 7 % atmospheric
         set(handles.text_size_h_HR,'Visible','On');
        set(handles.edit_size_h_HR,'Visible','On');
        set(handles.text_varh_HR,'Visible','On');
        set(handles.edit_varh_HR,'Visible','On');
        set(handles.text_size_h_HR,'String','Mask size (odd #):');
        h_size = round(abs(str2num(h_size)));
        if h_size - floor(h_size/2)*2 == 0,
            h_size = h_size +1;
            set(handles.edit_size_h_HR,'String',num2str(h_size));

        end
        set(handles.Radio,'Enable','on','Visible','on');
        set(handles.dataRadio,'Enable','on','Visible','on');
        dataRadio = get(handles.dataRadio,'String');

            if isempty(dataRadio) 
                 set(handles.edit_size_h_HR,'String','3.5');
            end
        
        set(handles.text_varh_HR,'String','Delta');
        set(handles.edit_varh_HR,'String','3.0');
        
        
end
  set(handles.pushbutton_SRG,'Enable','On');
handles.output = hObject;
guidata(hObject, handles);
        



% --- Executes during object creation, after setting all properties.
function popupmenu_Blur_HR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Blur_HR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_size_h_HR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_size_h_HR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_size_h_HR as text
%        str2double(get(hObject,'String')) returns contents of edit_size_h_HR as a double
h_size = get(handles.edit_size_h_HR,'String');

if isempty(h_size)
    h_size = 3;
    set(handles.edit_size_h_HR,'String',num2str(h_size));
end


handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_size_h_HR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_size_h_HR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_varh_HR_Callback(hObject, eventdata, handles)
% hObject    handle to edit_varh_HR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_varh_HR as text
%        str2double(get(hObject,'String')) returns contents of edit_varh_HR as a double


% --- Executes during object creation, after setting all properties.
function edit_varh_HR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_varh_HR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Blur_SR.
function popupmenu_Blur_SR_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Blur_SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Blur_SR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Blur_SR


% --- Executes during object creation, after setting all properties.
function popupmenu_Blur_SR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Blur_SR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable_trwarp.
function uitable_trwarp_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_trwarp (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in uitable_estwarp.
function uitable_estwarp_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_estwarp (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable_estwarp.
function uitable_estwarp_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_estwarp (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable_trwarp.
function uitable_trwarp_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_trwarp (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)



function value_degradationd_Callback(hObject, eventdata, handles)
% hObject    handle to value_degradationd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of value_degradationd as text
%        str2double(get(hObject,'String')) returns contents of value_degradationd as a double


% --- Executes during object creation, after setting all properties.
function value_degradationd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to value_degradationd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_Number_iteration_Callback(hObject, eventdata, handles)
% hObject    handle to text_Number_iteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_Number_iteration as text
%        str2double(get(hObject,'String')) returns contents of text_Number_iteration as a double
  
mode = get(handles.popupmenu_MODE,'Value');
method = get(handles.popupmenu_SRmet,'Value');
if mode == 1
    
      set(handles.text_Number_iteration,'Enable','on'); 
    iteration = get(handles.text_Number_iteration,'String');
    iterationNumber = str2num(iteration);
    if iterationNumber > handles.srimage.out.it
        iterationNumber = handles.srimage.out.it;
         set(handles.text_Number_iteration,'String',iterationNumber); 
    elseif iterationNumber < 1
        iterationNumber = 1;
         set(handles.text_Number_iteration,'String',iterationNumber); 
    end
   % if method ~= 7 & method ~= 8
    value_degradation = handles.srimage.out.history_value_degradation{iterationNumber};
     set(handles.value_degradation,'String',num2str(value_degradation));
   % end
    handles.srimage.x = handles.srimage.out.history_x{iterationNumber};
        
         handles.srimage.x = reshape(handles.srimage.x,[handles.opt.M,handles.opt.N]);
      
   axes(handles.HRimage);
         set(handles.text_Msr,'String',handles.opt.M);
        set(handles.text_Nsr,'String',handles.opt.N);
   
        if handles.opt.Color & handles.opt.Canal.Color > 0
            handles.srimage.xc = [];
            handles.srimage.xc = handles.srimageColor.out.history_x{iterationNumber};
            handles.srimage.xc = reshape(handles.srimage.xc,[handles.opt.M,handles.opt.N,3]);
           imshow(handles.srimage.xc); 
           imshow(fusionarColor(handles.srimage.x,handles.srimage.xc));
        else
        
           imshow(handles.srimage.x);
        end
         set(handles.text_Number_iteration,'String',iterationNumber); 
         value_degradation = handles.srimage.out.history_value_degradation{iterationNumber};
         set(handles.value_degradation,'String',num2str(value_degradation));
        
else
     set(handles.text_Number_iteration,'Enable','off'); 
end
    
handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function text_Runing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Runing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Radio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Radio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function dataRadio_Callback(hObject, eventdata, handles)
% hObject    handle to dataRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dataRadio as text
%        str2double(get(hObject,'String')) returns contents of dataRadio as a double


% --- Executes during object creation, after setting all properties.
function dataRadio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dataRadio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nfHRsimuled_Callback(hObject, eventdata, handles)
% hObject    handle to nfHRsimuled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nfHRsimuled as text
%        str2double(get(hObject,'String')) returns contents of nfHRsimuled as a double


% --- Executes during object creation, after setting all properties.
function nfHRsimuled_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nfHRsimuled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ncHRsimuled_Callback(hObject, eventdata, handles)
% hObject    handle to ncHRsimuled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ncHRsimuled as text
%        str2double(get(hObject,'String')) returns contents of ncHRsimuled as a double


% --- Executes during object creation, after setting all properties.
function ncHRsimuled_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ncHRsimuled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
