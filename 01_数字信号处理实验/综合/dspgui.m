function varargout = dspgui(varargin)
% DSPGUI MATLAB code for dspgui.fig
%      DSPGUI, by itself, creates a new DSPGUI or raises the existing
%      singleton*.
%
%      H = DSPGUI returns the handle to a new DSPGUI or the handle to
%      the existing singleton*.
%
%      DSPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSPGUI.M with the given input arguments.
%
%      DSPGUI('Property','Value',...) creates a new DSPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dspgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dspgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dspgui

% Last Modified by GUIDE v2.5 18-Apr-2026 09:38:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dspgui_OpeningFcn, ...
                   'gui_OutputFcn',  @dspgui_OutputFcn, ...
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


% --- Executes just before dspgui is made visible.
function dspgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dspgui (see VARARGIN)

% Choose default command line output for dspgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dspgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dspgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str_fs = get(handles.edit1,'String');
fs = str2double(str_fs);
handles.fs = fs;
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str_fs = get(handles.edit1,'String');
fs = str2double(str_fs);
handles.fs = fs;
guidata(hObject, handles);

flag = 0;
handles.flag = flag;
[file,path] = uigetfile({'*.mp3';'*.wav'},'选择音频文件');
if file == 0  % 用户取消了
        return;
end
[y,fs_old] = audioread(fullfile(path,file));
disp('原采样速率为：');
disp(fs_old);
fs_new = handles.fs;
y_nonoise = resample(y, fs_new, fs_old);
y_nonoise = y_nonoise(:, 1);
t = (0:length(y_nonoise)-1) / fs_new;
max_time = max(t);

handles.y_nonoise =y_nonoise;
guidata(hObject, handles);
% 在axes1上画图
plot(handles.axes1, t, y_nonoise);
xlim(handles.axes1, [0, max_time]);
xlabel(handles.axes1, '时间 (秒)');
ylabel(handles.axes1, '幅度');
title(handles.axes1, '音频时域波形');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y_nonoise = handles.y_nonoise;
flag = 0;
handles.flag = flag;
fs = handles.fs;
N = length(y_nonoise);

Y = fft(y_nonoise);                 % 快速傅里叶变换
Y_mag = abs(Y(1:N/2+1));    % 取幅值，只取一半（对称的）

% 2. 计算频率轴
f = (0:N/2) * fs / N;       % 频率范围：0 到 fs/2

% 3. 在axes2上画频谱
plot(handles.axes2, f, Y_mag);
xlabel(handles.axes2, '频率 (Hz)');
ylabel(handles.axes2, '幅值');
title(handles.axes2, '音频频谱图');
grid(handles.axes2, 'on');
handles.Y_mag = Y_mag;
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y_nonoise = handles.y_nonoise;
fs = handles.fs;
sound(y_nonoise,fs);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
Noisetype = get(handles.popupmenu1,'Value');
handles.Noisetype = Noisetype;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flag = 1;
handles.flag = flag;
Y_mag = handles.Y_mag;
Noisetype = handles.Noisetype;
y_nonoise = handles.y_nonoise;
fs = handles.fs;
t = (0:length(y_nonoise)-1) / fs;
max_time = max(t);

SNR_dB = str2double(get(handles.edit4,'String'));
SNR_line = 10^(SNR_dB/10);
signal_power = rms(y_nonoise)^2;
noise_power = signal_power/SNR_line;

switch Noisetype
    case 1
        Noise = sqrt(noise_power)*randn(size(y_nonoise));
    case 2
        Noise_raw = pinknoise(length(y_nonoise));
        Noise = sqrt(noise_power)*Noise_raw/rms(Noise_raw);
    case 3
        density = 0.05;
        Noise = impulse_noise(y_nonoise,density, sqrt(noise_power/density)); 
    case 4
        Noise = sin_noise(y_nonoise,fs,5000,sqrt(noise_power*2));
end
y_addnoise = y_nonoise + Noise;

handles.y_addnoise = y_addnoise;
guidata(hObject,handles);

plot(handles.axes3, t, y_addnoise,t, Noise,'r');
hold on;
xlabel(handles.axes3, '时间 (秒)');
ylabel(handles.axes3, '幅度');
xlim(handles.axes3,[0,max_time]);
title(handles.axes3, '音频时域波形');
hold off;

N = length(y_addnoise);

Y = fft(y_addnoise);                 % 快速傅里叶变换
Y_Noise = fft(Noise);
Y_mag = abs(Y(1:N/2+1));    % 取幅值，只取一半（对称的）
Y_Noise_mag = abs(Y_Noise(1:N/2+1));

f = (0:N/2) * fs / N;       % 频率范围：0 到 fs/2

plot(handles.axes4, f, Y_mag,f, Y_Noise_mag,'r');
hold on;
xlabel(handles.axes4, '频率 (Hz)');
ylabel(handles.axes4, '幅值');
title(handles.axes4, '加噪音频频谱图');
grid(handles.axes4, 'on');
hold off;
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
y_addnoise = handles.y_addnoise;
fs = handles.fs;
sound(y_addnoise,fs);


% --- Executes on button press in TagIIR.
function TagIIR_Callback(hObject, eventdata, handles)
% hObject    handle to TagIIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TagIIR


% --- Executes on button press in TagFIR.
function TagFIR_Callback(hObject, eventdata, handles)
% hObject    handle to TagFIR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TagFIR



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str_low = get(handles.edit2,'String');
str_high = get(handles.edit3,'String');
Low_jiezhi = str2num(str_low);
High_jiezhi = str2num(str_high);

handles.Low_jiezhi = Low_jiezhi;
handles.High_jiezhi = High_jiezhi;
guidata(hObject, handles);
Low_jiezhi
High_jiezhi


% --- Executes when selected object is changed in IIR.
function IIR_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in IIR 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('=== 滤波器选择回调被触发 ===');
current_FiterStyle = get(eventdata.NewValue,'Tag');
handles.FiterStyle = current_FiterStyle;
fs=handles.fs;
N = 1024;
f = (0:N-1) * fs/(2*N);
guidata(hObject, handles);
if isfield(handles, 'FiterStyle') && strcmp(handles.FiterStyle, 'TagIIR')
    disp('=== IIR被触发 ==='); 
    Low_jiezhi = handles.Low_jiezhi;
    High_jiezhi = handles.High_jiezhi;
    [H_mag,bz,az] = IIR(fs,Low_jiezhi,High_jiezhi);
    plot(handles.axes5, f, 20*log10(H_mag)');
    xlabel(handles.axes5, '频率 (Hz)');
    ylabel(handles.axes5, '幅值');
    title(handles.axes5, 'IIR滤波器幅频特性');
    grid(handles.axes5, 'on');

    xlim(handles.axes5, [0, fs/2]);

    handles.IIR_b = bz;
    handles.IIR_a = az;
    guidata(hObject, handles); 
else
     disp('=== FIR被触发 ===');   
end
guidata(hObject, handles);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('=== 窗函数选择回调被触发 ===');
current_Win = get(eventdata.NewValue,'Tag');
fs=handles.fs;
N = 1024;
f = (0:N-1) * fs/(2*N);
if isfield(handles, 'FiterStyle') && strcmp(handles.FiterStyle, 'TagFIR')
    Low_jiezhi = handles.Low_jiezhi;
    High_jiezhi = handles.High_jiezhi;
    [H_mag,h] = FIR(fs,current_Win,Low_jiezhi,High_jiezhi);
    plot(handles.axes5, f, 20*log10(H_mag)');
    xlabel(handles.axes5, '频率 (Hz)');
    ylabel(handles.axes5, '幅值');
    title(handles.axes5, 'FIR滤波器幅频特性');
    grid(handles.axes5, 'on');

    handles.FIR_h = h;
    guidata(hObject, handles); 
    xlim(handles.axes5, [0, fs/2]);        
end
    
guidata(hObject, handles);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.flag == 0
    y = handles.y_nonoise;
else
    y = handles.y_addnoise;
end
fs=handles.fs;
t = (0:length(y)-1) / fs;
max_time = max(t);

if isfield(handles, 'FiterStyle') && strcmp(handles.FiterStyle, 'TagFIR')
    h = handles.FIR_h;
    y_new = filter(h,1,y);
    plot(handles.axes6, t, y_new);
    xlim(handles.axes6,[0,max_time]);
    xlabel(handles.axes6, '时间 (秒)');
    ylabel(handles.axes6, '幅度');
    title(handles.axes6, '滤波后音频时域波形');

    N = length(y_new);              % 信号长度
    Y = fft(y_new);                 % 快速傅里叶变换
    Y_mag = abs(Y(1:N/2+1));    % 取幅值，只取一半（对称的）
    
    % 2. 计算频率轴
    f = (0:N/2) * fs / N;       % 频率范围：0 到 fs/2

    plot(handles.axes7, f, Y_mag);
    xlabel(handles.axes7, '频率 (Hz)');
    ylabel(handles.axes7, '幅值');
    title(handles.axes7, '音频频谱图');
    grid(handles.axes7, 'on');
    handles.y_new = y_new;
    guidata(hObject, handles);

end
if isfield(handles, 'FiterStyle') && strcmp(handles.FiterStyle, 'TagIIR')
    b = handles.IIR_b;
    a = handles.IIR_a;
    y_new = filter(b,a,y);
    plot(handles.axes6, t, y_new);
    xlim(handles.axes6,[0,max_time]);
    xlabel(handles.axes6, '时间 (秒)');
    ylabel(handles.axes6, '幅度');
    title(handles.axes6, '滤波后音频时域波形');

    N = length(y_new);              % 信号长度
    Y = fft(y_new);                 % 快速傅里叶变换
    Y_mag = abs(Y(1:N/2+1));    % 取幅值，只取一半（对称的）
    
    % 2. 计算频率轴
    f = (0:N/2) * fs / N;       % 频率范围：0 到 fs/2
    
    % 3. 在axes2上画频谱
    plot(handles.axes7, f, Y_mag);
    xlabel(handles.axes7, '频率 (Hz)');
    ylabel(handles.axes7, '幅值');
    title(handles.axes7, '音频频谱图');
    grid(handles.axes7, 'on');
    handles.y_new = y_new;
    guidata(hObject, handles);
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sound(handles.y_new, handles.fs);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str_fs = get(handles.edit1,'String');
fs = str2double(str_fs);
handles.fs = fs;
guidata(hObject, handles);
bits = 16;   
duration = 6;
channels = 1; 

recObj  = audiorecorder(fs, bits, channels)

disp('开始录制...');
recordblocking(recObj , duration);   
disp('录制结束');

audioData = getaudiodata(recObj);
play(recObj);

filename = fullfile(pwd, 'myRecording.wav');
audiowrite(filename, audioData, fs);

[y_nonoise, fs] = audioread(filename);

y_nonoise = y_nonoise(:, 1);
t = (0:length(y_nonoise)-1) / fs;
max_time = max(t);

handles.y_nonoise =y_nonoise;
guidata(hObject, handles);
% 在axes1上画图
plot(handles.axes1, t, y_nonoise);
xlim(handles.axes1, [0, max_time]);
xlabel(handles.axes1, '时间 (秒)');
ylabel(handles.axes1, '幅度');
title(handles.axes1, '音频时域波形');



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
