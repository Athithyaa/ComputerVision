function varargout = simpleApp(varargin)
% SIMPLEAPP MATLAB code for simpleApp.fig
%      SIMPLEAPP, by itself, creates a new SIMPLEAPP or raises the existing
%      singleton*.
%
%      H = SIMPLEAPP returns the handle to a new SIMPLEAPP or the handle to
%      the existing singleton*.
%
%      SIMPLEAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMPLEAPP.M with the given input arguments.
%
%      SIMPLEAPP('Property','Value',...) creates a new SIMPLEAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simpleApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simpleApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simpleApp

% Last Modified by GUIDE v2.5 08-Sep-2016 19:53:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simpleApp_OpeningFcn, ...
                   'gui_OutputFcn',  @simpleApp_OutputFcn, ...
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

% --- Executes just before simpleApp is made visible.
function simpleApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simpleApp (see VARARGIN)

% Choose default command line output for simpleApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simpleApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simpleApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = menu('choose imge', 'im1', 'im2');
image = imread('lena1.jpg');
imshow(image, 'Parent', handles.original);


% --- Executes on button press in meanfilter.
function meanfilter_Callback(hObject, eventdata, handles)
% hObject    handle to meanfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = imread('lena1.jpg');
imshow(meanFilter(image, 3), 'Parent', handles.filtered);

% --- Executes on button press in gaussFilter.
function gaussFilter_Callback(hObject, eventdata, handles)
% hObject    handle to gaussFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
imshow([], 'Parent', handles.original);
imshow([], 'Parent', handles.filtered);