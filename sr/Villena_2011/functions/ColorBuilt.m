function [handles] = ColorBuilt(method,handles)
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

 handles.opt.Canal.maxit = handles.srimage.out.it;

  handles.opt.Canal.sx = handles.srimage.out.sx;
  handles.opt.Canal.sy = handles.srimage.out.sy;
    handles.opt.Canal.theta = handles.srimage.out.theta;
   


mode = get(handles.popupmenu_MODE,'Value');
 set(handles.text_Number_iteration,'Enable','off');
for ic= 1:3
    handles.opt.Canal.Color = ic;
    yc = [];
    for iob = 1:handles.opt.L
        aux = handles.LRi(:,:,ic,iob);
        yc = [yc;aux(:)];
    end
    
        
        
    switch method
        case 2

            [handles.srimage.xc(:,ic),handles.srimageC.out] = ...
                solvex_var(yc,handles.opt,handles.HRimage,handles);
        case 3
            
             [handles.srimage.xc(:,ic),handles.srimageC.out] = ...
                        solvex_varL4(yc,handles.opt,handles.HRimage,handles);  
        case 4
             [handles.srimage.xc(:,ic),handles.srimageC.out] = ...
                        solvex_varL4SAR(yc,handles.opt,handles.HRimage,handles);  
        case 5
             [handles.srimage.xc(:,ic),handles.srimageC.out] = ...
                        solvex_varL4SAR(yc,handles.opt,handles.HRimage,handles);  
            
        case 6
             [handles.srimage.xc(:,ic),handles.srimageC.out] = ...
                        solvex_varTVSAR(yc,handles.opt,handles.HRimage,handles);
       
            
        case 7
            [handles.srimage.xc(:,ic),handles.srimageC.out] = ...
                        solvex_sumpriorSRVarPGMIX(yc,handles.opt,handles.HRimage,handles);
                    
        
    end
    
    if mode == 1
            clear handles.srimageColor.out.history_x;
            for ixc = 1: handles.srimageC.out.it
                handles.srimageColor.out.history_x{ixc}(:,ic) = ...
                    handles.srimageC.out.history_x{ixc}(:);
            end
            
    else  % mode = 2 Simuled
            
         handles.srimageC.xcBest(:,:,ic) = handles.srimageC.out.maxPSNR_x;
         
    end
    clear handles.srimageC.out

    clear yc
end
if mode == 1 
    set(handles.text_Number_iteration,'Enable','on'); 
end