clc; clear all; close all;

%% 1. 参数设置
fs = 1e6;                           
n_bits = 64e3;                      
M = 4;                              
K = log2(M);                        
N_FFT = 128;                         
NCP = 16;                           
EbN0_dB = 15;                       
% --- 核心：过采样设置 ---
L = 2;                               
N_FFT_OS = N_FFT * L;               
NSYM_OS = N_FFT_OS + NCP;            

sign_base = randi([0 1], n_bits, 1);
symIdx = bit2int(sign_base, K);
sign_mod = qammod(symIdx, M, 'UnitAveragePower', true);

% 串并转换
sign_OFDM_perFFT = reshape(sign_mod, N_FFT, []); 

sign_freq_padded = zeros(N_FFT_OS, size(sign_OFDM_perFFT, 2));
sign_freq_padded(1:N_FFT/2, :) = sign_OFDM_perFFT(1:N_FFT/2, :);
sign_freq_padded(end-N_FFT/2+1:end, :) = sign_OFDM_perFFT(N_FFT/2+1:end, :);

% IFFT
sign_OFDM_IFFT = ifft(sign_freq_padded, N_FFT_OS, 1);

sign_OFDM_AddCP = [sign_OFDM_IFFT(end-NCP+1:end, :); sign_OFDM_IFFT];
signal_trans = sign_OFDM_AddCP(:); 

%% 3. 经过瑞利多径信道
tau = [0 1/fs 3/fs];                
pdb = [0 -3 -5];                    
rayChannel = comm.RayleighChannel('SampleRate', fs, ...
    'PathDelays', tau, ...
    'AveragePathGains', pdb, ...
    'MaximumDopplerShift', 0, ...
    'PathGainsOutputPort', true);

[signal_faded, pathGains] = rayChannel(signal_trans);

snr_dB = EbN0_dB + 10*log10(K); 
signal_receive = awgn(signal_faded, snr_dB, 'measured');

%% 信道频率响应 
delaySamples = round(tau .* fs);
h_time = zeros(N_FFT_OS, 1); 
currentGains = pathGains(1, :); 
for i = 1:length(delaySamples)
    h_time(delaySamples(i) + 1) = currentGains(i);
end
H_freq = fft(h_time, N_FFT_OS); 

% OFDM解调
signal_rec_reshape = reshape(signal_receive, NSYM_OS, []);
signal_rec_NoCP = signal_rec_reshape(NCP+1:end, :);
signal_rec_fft = fft(signal_rec_NoCP, N_FFT_OS, 1);

% ZF
signal_eq_full = signal_rec_fft ./ H_freq;

signal_eq = [signal_eq_full(1:N_FFT/2, :); signal_eq_full(end-N_FFT/2+1:end, :)];

signal_rec_final = qamdemod(signal_eq(:), M, ...
    'OutputType', 'bit', 'UnitAveragePower', true);

%% 误码率计算
ber = sum(sign_base ~= signal_rec_final) / length(sign_base);
fprintf('当前 Eb/N0 = %d dB, 误码率(BER): %.10f \n', EbN0_dB, ber);

%% 图1：星座图（发送 vs 接收）
figure('Units', 'inches', 'Position', [1, 1, 8, 4]);
subplot(1,2,1);
plot(sign_mod, 'ro'); 
title('发送端星座图'); 
axis([-2 2 -2 2]); 
grid on; 
xlabel('同相分量'); ylabel('正交分量');

subplot(1,2,2);
plot(signal_eq(:), 'bo', 'MarkerSize', 2); 
title('接收端均衡后星座图'); 
axis([-2 2 -2 2]); 
grid on; 
xlabel('同相分量'); ylabel('正交分量');


%% 图2：时域波形对比（发送 vs 接收）
sampleRange = 1 : 2*(N_FFT+NCP); 
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);
subplot(2,1,1);
plot(real(signal_trans(sampleRange)), 'LineWidth', 1);
grid on;
title('发送端时域波形');
xlabel('采样点'); ylabel('幅度');

subplot(2,1,2);
plot(real(signal_receive(sampleRange)), 'Color', 'r', 'LineWidth', 1);
grid on;
title('信道输出端时域波形');
xlabel('采样点'); ylabel('幅度');


%% 图3：功率谱分析（发送 vs 接收）
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

subplot(2,1,1);
[pxx_tr, f_tr] = pwelch(signal_trans, hamming(512), 256, 1024, fs, 'centered');
plot(f_tr/1e3, 10*log10(pxx_tr/max(pxx_tr)), 'LineWidth', 1.5);
grid on;
title('带过采样的 OFDM 发送端功率谱');
xlabel('频率 (kHz)'); ylabel('相对功率 (dB)');
ylim([-60 5]);

subplot(2,1,2);
[pxx_rx, f_rx] = pwelch(signal_receive, hamming(512), 256, 1024, fs, 'centered');
plot(f_rx/1e3, 10*log10(pxx_rx/max(pxx_rx)), 'LineWidth', 1.5);
grid on;
title('经过信道 OFDM 功率谱');
xlabel('频率 (kHz)'); ylabel('相对功率 (dB)');
ylim([-60 5]);
