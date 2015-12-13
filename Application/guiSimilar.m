function varargout = guiSimilar(varargin)
% GUISIMILAR MATLAB code for guiSimilar.fig
%      GUISIMILAR, by itself, creates a new GUISIMILAR or raises the existing
%      singleton*.
%
%      H = GUISIMILAR returns the handle to a new GUISIMILAR or the handle to
%      the existing singleton*.
%
%      GUISIMILAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISIMILAR.M with the given input arguments.
%
%      GUISIMILAR('Property','Value',...) creates a new GUISIMILAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiSimilar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiSimilar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiSimilar

% Last Modified by GUIDE v2.5 12-Dec-2015 15:56:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiSimilar_OpeningFcn, ...
                   'gui_OutputFcn',  @guiSimilar_OutputFcn, ...
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


% --- Executes just before guiSimilar is made visible.
function guiSimilar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiSimilar (see VARARGIN)

% Choose default command line output for guiSimilar
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiSimilar wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiSimilar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1Similar.
function listbox1Similar_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1Similar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1Similar contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1Similar


% --- Executes during object creation, after setting all properties.
function listbox1Similar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1Similar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
