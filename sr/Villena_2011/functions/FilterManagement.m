function varargout = FilterManagement(varargin)
% FILTERMANAGEMENT MATLAB code for FilterManagement.fig
%      FILTERMANAGEMENT, by itself, creates a new FILTERMANAGEMENT or raises the existing
%      singleton*.
%
%      H = FILTERMANAGEMENT returns the handle to a new FILTERMANAGEMENT or the handle to
%      the existing singleton*.
%
%      FILTERMANAGEMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERMANAGEMENT.M with the given input arguments.
%
%      FILTERMANAGEMENT('Property','Value',...) creates a new FILTERMANAGEMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FilterManagement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FilterManagement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FilterManagement

% Last Modified by GUIDE v2.5 28-Sep-2013 11:58:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FilterManagement_OpeningFcn, ...
                   'gui_OutputFcn',  @FilterManagement_OutputFcn, ...
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


% --- Executes just before FilterManagement is made visible.
function FilterManagement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FilterManagement (see VARARGIN)

% Choose default command line output for FilterManagement

handles.filterlistsave = 0;
handles.fulllist = 0;
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

 %UIWAIT makes FilterManagement wait for user response (see UIRESUME)
 %uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FilterManagement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on selection change in filterList.
function filterList_Callback(hObject, eventdata, handles)
% hObject    handle to filterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filterList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filterList

handles.indlist = get(handles.filterList,'Value');
set(handles.vdelete,'Enable','On');



handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filterList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in vload.
function vload_Callback(hObject, eventdata, handles)
% hObject    handle to vload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


indlist =get(handles.filterList,'Value');
olddatalist = get(handles.filterList,'String');
if ischar(olddatalist)
    olddatalist = cellstr(olddatalist);
end 
if strcmp (get(handles.vnew,'String'),'INSERT') %size(olddatalist,1) > 0 
      selection = questdlg(' Load List of Filters ',...
        ' Warning!!',...
        'Append List', 'Exit','Append List');
   
 if strcmp (selection, 'Append List')    
    [f_name,n_route,index]=uigetfile({'*_FilterList.mat'},'Load List of Filters');
    handles.filterlistsave = 0;

    if index == 1
        handles.filterlistsave = 0;
         handles.fulllist = 1;
        load([n_route f_name],'F','filternames','datalist');
        olddatalist = get(handles.filterList,'String');
        oldsize = size(handles.F,2);
        handles.datalist = olddatalist;
        addsize = size(F,2);
        ii = 0;
        for i=oldsize+1: oldsize+addsize
            ii= ii+1;
            handles.F{i }= F{ii};
            handles.filternames{i} = filternames{ii};
            handles.datalist{i,1} = datalist{ii};
        end
        valuebox = oldsize+addsize -1;

       % handles.datalist = [olddatalist ; datalist];
        set(handles.filterList,'String',handles.datalist,'Value',1);
        
        set(handles.vsave, 'Enable','on');
        set(handles.vdelete,'Enable','on');
        set(handles.vexit,'Enable','on');
        
        
    end
 end % Don't load filter list
%set(handles.pushbutton_exit,'Enable','on');
else
    handles.fulllist = 0;
    [f_name,n_route,index]=uigetfile({'*_FilterList.mat'},'Load List of Filters');
   
    if index == 1
         handles.filterlistsave = 1;
         handles.fulllist = 1;
        load([n_route f_name],'F','filternames','datalist');
        set(handles.filterList,'String',datalist);
        handles.F = F;
        handles.filternames = filternames;
         set(handles.vsave, 'Enable','on');
        set(handles.vdelete,'Enable','on');
        set(handles.vexit,'Enable','on');
        set(handles.vnew, 'String','INSERT');
        handles.indlist = size(datalist,1);
    else
        warndlg('Error in Load List of Filters');
    end
end

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in vsave.
function vsave_Callback(hObject, eventdata, handles)
% hObject    handle to vsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.fulllist
    [f_name,n_route,index]=uiputfile('*_FilterList.mat','Save Filter List');
     f_name = sprintf('%s_FilterList.mat',f_name(1:end-4));
    if index == 1

        F = handles.F;
        filternames = handles.filternames;
        if size(F,2) == size(filternames,2)
            datalist = get(handles.filterList,'String');
            save([n_route f_name],'F','filternames','datalist');
            
             selection = questdlg('Salving Filter list',...
                 'Choice Option',...
                 'Begin New List','Using Actual List','Begin New List');
             if strcmp (selection, 'Begin New List')           
                     handles.filterlistsave = 0;
                      handles.fulllist = 0;
                    set(handles.vnew,'String','NEW');
                    set(handles.filterList,'String',cellstr(''));
                    set(handles.vdelete,'Enable','off');
             else
                 handles.filterlistsave = 1;
             end
        else
            warndlg('Error the Filter and names number are different',...
                'The list of filters are not saved'); 
        end
    else
        
        warndlg('Error output file name. The filter list is not saved');

    end
else
   warndlg('Empty List, it can not saved'); 
end
handles.output = hObject;
guidata(hObject, handles);

 
% --- Executes on button press in vnew.
function vnew_Callback(hObject, eventdata, handles)
% hObject    handle to vnew (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.vnewFilter, 'Enable', 'on');

datalist = get(handles.filterList,'String');
if ischar(datalist)
    datalist = cellstr(datalist);
end 

if strcmp(get(handles.vnew,'String'),'NEW')
    handles.indlist = 1;
    handles.fulllist = 0;
    handles.filterlistsave = 0;
else
    handles.indlist = size(datalist,1)+1;
     handles.fulllist = 1;
    
end
[f_name,n_route,index]=uigetfile({'*.mat'},'Load Filter');
handles.filterlistsave = 0;

if index == 1
    datalist{handles.indlist,1} = f_name;
    set(handles.filterList,'String',datalist);
    handles.fulllist = 1;
    handles.filterlistsave = 0;
    %handles.indlist = get(handles.filterList,'Value');
    load([n_route f_name],'datafilter');
    handles.F{handles.indlist}= datafilter;
    handles.filternames{handles.indlist}= f_name;
    if strcmp(get(handles.vnew,'String'),'NEW')
        set(handles.vnew,'String','INSERT');
        set(handles.vsave,'Enable','on');
        set(handles.vdelete,'Enable','on');
    end
else
    warndlg('Error: Filter do not reads');
end
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in vdelete.
function vdelete_Callback(hObject, eventdata, handles)
% hObject    handle to vdelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.indlist = get(handles.filterList,'Value');
handles.datalist = get(handles.filterList,'String');
toplist = size(handles.datalist,1);
if handles.indlist < toplist
    for i = 1:handles.indlist
        nw_datalist{i,1}= handles.datalist{i,1};
        nw_F{i} =  handles.F{i};
        nw_filternames{i} =  handles.filternames{i};
    end
    for i = handles.indlist:toplist-1
        nw_datalist{i,1} = handles.datalist{i+1,1};
        nw_F{i} = handles.F{i+1};
        nw_filternames{i} = handles.filternames{i+1};
    end
    handles.datalist = nw_datalist;
    handles.F = nw_F;
    handles.filternames = nw_filternames;
     handles.filterlistsave = 0;
    
    set(handles.filterList,'String',handles.datalist,'Value',1);
elseif toplist == handles.indlist
     handles.filterlistsave = 0;
    if toplist > 1
       %nw_datalist{1,1}= cellstr([]);
       
        for i=1:handles.indlist-1
            nw_datalist{i,1}= handles.datalist{i,1};
            nw_F{i} =  handles.F{i};
            nw_filternames{i} =  handles.filternames{i};
        end
        handles.datalist = nw_datalist;
        handles.F = nw_F;
        handles.filternames = nw_filternames;
        
        set(handles.filterList,'String',handles.datalist,'Value',1);
    else
        set(handles.filterList,'String',cellstr(''),'Value',1);
       
        handles.fulllist = 0;
        set(handles.vnew,'String','NEW');
    end
end
    

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in vedit.
function vedit_Callback(hObject, eventdata, handles)
% hObject    handle to vedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in vexit.
function vexit_Callback(hObject, eventdata, handles)
% hObject    handle to vexit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  sale = 1;
if handles.filterlistsave == 0 && handles.fulllist 
    selection = questdlg(' The Selected Filter List is not saved ',...
        ' Warning!!',...
        'Selection does not End', 'Selection ends without Salving','Selection does not End');
    switch selection
        case 'Selection does not End'
            sale = 0;
        case 'Selction ends without Salving'
            sale = 1;
    end
end

if sale && handles.fulllist == 0
      selection = questdlg(' The Selected Filter List is Empty ',...
        ' Warning!!',...
        'Not Finishing', 'You select only the Laplacian Filter','Not Finishing');
    switch selection
        case  'Not Finishing'
            sale = 0;
        case 'You select only the Laplacian Filter'
            sale = 1;
            handles.F{1}= [0 -0.25 0;-0.25 1 -0.25; 0 -0.25 0];
            handles.filternames{1}= 'Laplacian Filter';
            
    end
end
    
handles.output = hObject;
guidata(hObject, handles);
if sale 
    F = handles.F;
    filternames =  handles.filternames;
%     varargout{2}= F;
%     varargout{3} = filternames;
    
    save('tempSR/Filter.mat','F','filternames');
    handles.output = hObject;
    guidata(hObject, handles);

    close(handles.figure1);
end

% --- Executes on button press in vloadFilter.
function vloadFilter_Callback(hObject, eventdata, handles)
% hObject    handle to vloadFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in vsaveFilter.
function vsaveFilter_Callback(hObject, eventdata, handles)
% hObject    handle to vsaveFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in vnewFilter.
function vnewFilter_Callback(hObject, eventdata, handles)
% hObject    handle to vnewFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Filter;


% --- Executes on button press in vdeleteFilter.
function vdeleteFilter_Callback(hObject, eventdata, handles)
% hObject    handle to vdeleteFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in vviewFilter.
function vviewFilter_Callback(hObject, eventdata, handles)
% hObject    handle to vviewFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume();
delete(hObject);
