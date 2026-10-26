Fs = 1000;
Fp = 100;
Fst = 175;
Ap = 1;
As = 15;

Wp = Fp/(Fs/2);
Wst = Fst/(Fs/2);

% IIR 巴特沃斯滤波器设计
[n, Wn] = buttord(Wp, Wst, Ap, As);
[b, a] = butter(n, Wn);

[H_iir, w_iir] = freqz(b, a, 1024);
mag_iir = abs(H_iir);
phase_iir = angle(H_iir);              
mag_iir_dB = 20*log10(mag_iir);

% FIR 滤波器设计（汉明窗）
deltaw = Wst - Wp;       
N0 = ceil(6.6 / deltaw);  
N = N0 + mod(N0+1, 2);       
alfa = (N-1)/2;         
wc = (Wp + Wst)/2;              
n = 0:N-1;
hd = wc * sinc(wc * (n - alfa));    
win = hamming(N).';
h = hd .* win;
[H_fir, w_fir] = freqz(h, 1, 1024);

% 创建图形窗口（宽8英寸，高6英寸）
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

% 子图1：IIR 幅度特性 (dB)
subplot(2,2,1);
plot(w_iir, mag_iir_dB - mag_iir_dB(1), 'r-', 'LineWidth', 1);
grid on;
xlim([0, pi]);
title('IIR 巴特沃斯幅度特性');
xlabel('频率 (rad)');
ylabel('相对幅度 (dB)');

% 子图2：IIR 相位特性
subplot(2,2,2);
plot(w_iir, phase_iir, 'r-', 'LineWidth', 1);
grid on;
xlim([0, pi]);
title('IIR 巴特沃斯相位特性');
xlabel('频率 (rad)');
ylabel('相位 (rad)');

% 子图3：FIR 幅度特性 (dB)
subplot(2,2,3);
plot(w_fir, 20*log10(abs(H_fir)), 'b-', 'LineWidth', 1);
grid on;
xlim([0, pi]);
title('FIR 汉明窗幅度特性');
xlabel('频率 (rad)');
ylabel('幅度 (dB)');

% 子图4：FIR 相位特性 (归一化)
subplot(2,2,4);
plot(w_fir, angle(H_fir)/pi, 'b-', 'LineWidth', 1);
grid on;
xlim([0, pi]);
title('FIR 汉明窗相位特性');
xlabel('频率 (rad)');
ylabel('相位 (\times\pi rad)');

% 总标题
sgtitle('IIR 与 FIR 低通滤波器性能对比');
