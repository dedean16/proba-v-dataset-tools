function varargout = Filter(varargin)
% FILTER MATLAB code for Filter.fig
%      FILTER, by itself, creates a new FILTER or raises the existing
%      singleton*.
%
%      H = FILTER returns the handle to a new FILTER or the handle to
%      the existing singleton*.
%
%      FILTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTER.M with the given input arguments.
%
%      FILTER('Property','Value',...) creates a new FILTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Filter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Filter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Filter

% Last Modified by GUIDE v2.5 26-Sep-2013 11:55:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Filter_OpeningFcn, ...
                   'gui_OutputFcn',  @Filter_OutputFcn, ...
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


% --- Executes just before Filter is made visible.
function Filter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Filter (see VARARGIN)

% Choose default command line output for Filter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Filter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Filter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f_name,n_route,index]=uigetfile({'*.mat'},'Load Filter');
handles.filtersave = 0;
if index == 1
    handles.filtersave = 1;
    load([n_route f_name],'datafilter');
   
    [m,n] =size(datafilter);
    if m ~= n
        warndlg({'Filter Matrix must be square.'},'Invalid Value');
    else
        set(handles.uitable,'visible','on');
        set(handles.uitable,'Data',datafilter);
        set(handles.sizefilter,'String',num2str(m));
        handles.sizefilter = m;
        handles.datafilter = datafilter;
        set(handles.pushbutton_save,'Enable','on');

    end
end
set(handles.pushbutton_exit,'Enable','on');
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f_name,n_route,index]=uiputfile('*.mat','Save Filter');

if index == 1
    datafilter = get(handles.uitable,'Data');
    if sum(datafilter(:)) ~= 0
         datafilter = datafilter/sum(datafilter(:));
    end
    save([n_route f_name],'datafilter');
    hndles.datafilter = datafilter;
    handles.filtersave = 1;
    
end
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton_exit.
function pushbutton_exit_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  sale = 1;
if exist('handles.filtersave')
    if handles.filtersave == 0
        selection = questdlg(' The filter is not saved ',...
            ' Warning!!',...
            'Cancel', 'Exit','Cancel');
        switch selection
            case 'Cancel'
                sale = 0;
            case 'Exit'
                sale = 1;
        end
    end

handles.output = hObject;
guidata(hObject, handles);
if sale 
    close(handles.figure1);
end
else
    close(handles.figure1);
end
function sizefilter_Callback(hObject, eventdata, handles)
% hObject    handle to sizefilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizefilter as text
%        str2double(get(hObject,'String')) returns contents of sizefilter as a double

set(handles.pushbutton_save,'Enable','off');
set(handles.pushbutton_exit,'Enable','off');
sizefilter = get(gcbo,'String');
sizefilter = str2num(sizefilter);
handles.filtersave = 0;

if isempty(sizefilter)
    warndlg({'Invalid Size value.','Using 3 '},'Invalid Value');
    set(gcbo,'String','3');
    sizefilter = 3;
end

sizefilter = round(abs((sizefilter)));
if sizefilter - floor(sizefilter/2)*2 == 0,
    sizefilter = sizefilter +1;
    set(gcbo,'String',num2str(sizefilter));

end

set(handles.uitable,'Data',zeros(sizefilter));
set(handles.uitable,'Visible','on');
set(handles.pushbutton_save,'Enable','on');
set(handles.pushbutton_exit,'Enable','on');
%set(handles.uitable,'ColumnWidth',num2cell(25*ones(1,sizeh)));
handles.sizefilter=sizefilter;
handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sizefilter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizefilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
