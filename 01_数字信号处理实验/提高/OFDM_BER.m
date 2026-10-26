clc; clear all; close all;

%% 1. 参数设置
fs = 1e6;                           
n_bits = 64e5;                       % 总比特数
M = 4;                              % QPSK
K = log2(M);                        
N_FFT = 128;                         
NCP = 16;
NSYM = N_FFT + NCP;
bits_per_symbol = N_FFT * K; 

% 仿真点设置
EbN0_dB = 0:1:10;                   
num_blocks = 200;      

% 确保样本量拆分为整数
n_bits_per_block = ceil((n_bits/num_blocks) / bits_per_symbol) * bits_per_symbol;
n_bits = n_bits_per_block * num_blocks;

ber_zf = zeros(1,length(EbN0_dB));

% --- 信道归一化 ---
tau = [0 1/fs 5/fs];                
pdb_raw = [0 -3 -5];                
pdb_lin = 10.^(pdb_raw/10);
pdb_norm = 10*log10(pdb_lin / sum(pdb_lin)); 

rayChannel = comm.RayleighChannel('SampleRate', fs, ...
    'PathDelays', tau, ...
    'AveragePathGains', pdb_norm, ...
    'MaximumDopplerShift', 0, ...
    'PathGainsOutputPort', true);

%% 2. 仿真循环
for idx = 1:length(EbN0_dB)
    total_err_zf = 0;
    
    for b = 1:num_blocks
        % 数据生成与调制
        sign_base = randi([0 1], n_bits_per_block, 1); 
        symIdx = bit2int(sign_base, K);
        sign_mod = qammod(symIdx, M, 'UnitAveragePower', true);
        
        % OFDM 调制
        sign_OFDM_perFFT = reshape(sign_mod, N_FFT, []); 
        sign_OFDM_IFFT = ifft(sign_OFDM_perFFT, N_FFT, 1);
        sign_OFDM_AddCP = [sign_OFDM_IFFT(end-NCP+1:end, :); sign_OFDM_IFFT];
        signal_trans = sign_OFDM_AddCP(:); 
        
        % 经过信道
        reset(rayChannel);
        [signal_faded, pathGains] = rayChannel(signal_trans);
        
        % 计算考虑CP损耗的SNR
        cp_loss = 10*log10((N_FFT + NCP) / N_FFT);
        snr_dB = EbN0_dB(idx) + 10*log10(K) - cp_loss; 
        signal_receive = awgn(signal_faded, snr_dB, 'measured');
        
        % 理想信道估计
        delaySamples = round(tau .* fs);
        h_time = zeros(N_FFT, 1); 
        currentGains = pathGains(1, :); 
        for i = 1:length(delaySamples)
            h_time(delaySamples(i) + 1) = currentGains(i);
        end
        H_freq = fft(h_time, N_FFT); 
        
        % --- 解调关键步骤 ---
        signal_rec_reshape = reshape(signal_receive, NSYM, []);
        signal_rec_fft = fft(signal_rec_reshape(NCP+1:end, :), N_FFT, 1);
        
        % 2. ZF 均衡
        sig_eq_zf = signal_rec_fft ./ H_freq;
        
        % 判决与误差累计
        rec_zf = qamdemod(sig_eq_zf(:), M, 'OutputType', 'bit', 'UnitAveragePower', true);
        total_err_zf = total_err_zf + sum(sign_base ~= rec_zf);
    end
    ber_zf(idx) = total_err_zf / n_bits;
    fprintf('BER: %.2e\n', ber_zf(idx));
end

%% 3. 绘图比较（导出为无白边 PDF）
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

semilogy(EbN0_dB, ber_zf, 'bs--', 'LineWidth', 1.5, 'DisplayName', 'OFDM+QPSK仿真Rayleigh信道');
hold on;

ber_rayleigh = berfading(EbN0_dB, 'psk', M, 1); 
semilogy(EbN0_dB, ber_rayleigh, 'r-', 'LineWidth', 2, 'DisplayName', '理论Rayleigh');

ber_awgn = berawgn(EbN0_dB, 'psk', M, 'nondiff');
semilogy(EbN0_dB, ber_awgn, 'k-.', 'LineWidth', 2, 'DisplayName', 'QPSK理论');

grid on; 
xlabel('E_b/N_0 (dB)');
ylabel('误码率 (BER)');
title('OFDM系统误码率曲线对比');
legend('Location', 'SouthWest');
axis([min(EbN0_dB) max(EbN0_dB) 1e-5 1]);
