function varargout = myfig(varargin)
% MYFIG MATLAB code for myfig.fig
%      MYFIG, by itself, creates a new MYFIG or raises the existing
%      singleton*.
%
%      H = MYFIG returns the handle to a new MYFIG or the handle to
%      the existing singleton*.
%
%      MYFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYFIG.M with the given input arguments.
%
%      MYFIG('Property','Value',...) creates a new MYFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myfig

% Last Modified by GUIDE v2.5 18-Apr-2026 14:07:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myfig_OpeningFcn, ...
                   'gui_OutputFcn',  @myfig_OutputFcn, ...
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


% --- Executes just before myfig is made visible.
function myfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myfig (see VARARGIN)

% Choose default command line output for myfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = myfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y_new = handles.y_new;
fs = handles.fs;
sound(y_new,fs);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile({'*.mp3';'*.wav'},'选择音频文件');
if file == 0  % 用户取消了
        return;
end
[y,fs] = audioread(fullfile(path,file));
handles.fs = fs;
y = y(:, 1);
t = (0:length(y)-1) / fs;
max_time = max(t);

handles.y =y;
guidata(hObject, handles);

plot(handles.axes1, t, y);
xlim(handles.axes1, [0, max_time]);
xlabel(handles.axes1, '时间 (秒)');
ylabel(handles.axes1, '幅度');
title(handles.axes1, '音频时域波形');
%%
N = length(y);

Y = fft(y);                 % 快速傅里叶变换
Y_mag = abs(Y(1:N/2+1)); 
f = (0:N/2) * fs / N; 

plot(handles.axes2, f, Y_mag);
xlabel(handles.axes2, '频率 (Hz)');
ylabel(handles.axes2, '幅值');
title(handles.axes2, '音频频谱图');
grid(handles.axes2, 'on');
handles.Y_mag = Y_mag;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y = handles.y;
fs = handles.fs;
sound(y,fs);

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
Type = get(handles.popupmenu1,'Value');
handles.Type = Type;
fs = handles.fs;

    y = handles.y;
    t = (0:length(y)-1) / fs;
    N = 1024;
    f = (0:N-1) * fs/(2*N);
    guidata(hObject,handles);

    [H_mag,h] = FIR(fs,Type);
    plot(handles.axes3, f, 20*log10(H_mag)');
    xlabel(handles.axes3, '频率 (Hz)');
    ylabel(handles.axes3, '幅值');
    title(handles.axes3, 'FIR滤波器幅频特性');
    grid(handles.axes3, 'on');

    handles.FIR_h = h;
    guidata(hObject, handles); 
    xlim(handles.axes3, [0, fs/2]);

    y_new = filter(h,1,y);
    max_time = max(t);
    plot(handles.axes4, t, y_new);
    xlim(handles.axes4,[0,max_time]);
    xlabel(handles.axes4, '时间 (秒)');
    ylabel(handles.axes4, '幅度');
    title(handles.axes4, '滤波后音频时域波形');

    N = length(y_new);              % 信号长度
    Y = fft(y_new);                 % 快速傅里叶变换
    Y_mag = abs(Y(1:N/2+1));    % 取幅值，只取一半（对称的）
    f = (0:N/2) * fs / N; 
    % 2. 计算频率轴

    plot(handles.axes5, f, Y_mag);
    xlabel(handles.axes5, '频率 (Hz)');
    ylabel(handles.axes5, '幅值');
    title(handles.axes5, '音频频谱图');
    grid(handles.axes5, 'on');
    handles.y_new = y_new;
    guidata(hObject, handles);
