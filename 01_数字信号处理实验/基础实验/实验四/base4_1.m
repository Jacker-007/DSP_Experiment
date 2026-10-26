clear all;
wp = 0.2;
ws = 0.35;

deltaw = ws - wp;
N0 = ceil(6.6 / deltaw);   % 选择汉明窗，求滤波器长度N0
N = N0 + mod(N0+1, 2);     % 选择1型滤波器，确保N为奇数
alfa = (N-1)/2;
wc = (wp + ws) / 2;
windows = hamming(N);      % 汉明窗
n = 0:N-1;
hd = wc * sinc(wc * (n - alfa));
h = hd .* windows';

[H, w] = freqz(h, 1);

% 创建图形窗口，固定大小（宽8英寸，高6英寸）
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

subplot(2,2,1);
stem(n, hd);
axis([0, N-1, -0.1, 0.3]);
title('理想冲激响应');
ylabel('hd(n)');

subplot(2,2,2);
stem(n, h);
axis([0, N-1, -0.1, 0.3]);
title('实际冲激响应');
ylabel('h(n)');

subplot(2,2,3);
plot(w/pi, 20*log10(abs(H) / abs(H(1))));
axis([0, 1, -100, 10]);
title('FIR滤波器幅度特性');
ylabel('H(dB)');
xlabel('频率 (×π rad)');

subplot(2,2,4);
plot(w/pi, angle(H) / pi);
title('FIR滤波器相位特性');
ylabel('相位 (×π rad)');
xlabel('频率 (×π rad)');
