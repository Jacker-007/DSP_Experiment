clear all;
wp = 0.2;
ws = 0.35;

deltaw = ws - wp;
N0 = ceil(6.6 / deltaw);            % 选择汉明窗，求滤波器长度N0
N = N0 + mod(N0+1, 2);              % 选择1型滤波器，确保N为奇数
N_list = [N-20, N, N+20];
alfa = (N_list - 1) / 2;
wc = (wp + ws) / 2;
LineColor_List = ['r', 'b', 'g'];

% 创建图形窗口，固定大小（宽8英寸，高6英寸）
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

subplot(2,1,1);
for i = 1:3
    windows = hamming(N_list(i));    % 汉明窗
    n = 0:N_list(i)-1;
    hd = wc * sinc(wc * (n - alfa(i)));
    h = hd .* windows';
    [H, w] = freqz(h, 1, 1024);
    hold on;
    plot(w, abs(H), 'LineStyle', '-', 'Color', LineColor_List(i), 'LineWidth', 1);
    hold off;
end
legend('N = 25', 'N = 45', 'N = 65');
ylim([0, 1.1]);
xlim([0, pi]);
xlabel('频率 (rad)');
ylabel('幅值 |H(e^{j\omega})|');
title('FIR 滤波器幅频特性（线性）');
grid on;

subplot(2,1,2);
for i = 1:3
    windows = hamming(N_list(i));    % 汉明窗
    n = 0:N_list(i)-1;
    hd = wc * sinc(wc * (n - alfa(i)));
    h = hd .* windows';
    [H, w] = freqz(h, 1, 1024);
    H_dB = 20 * log10(abs(H));
    hold on;
    plot(w, H_dB - H_dB(1), 'LineStyle', '-', 'Color', LineColor_List(i), 'LineWidth', 1);
    hold off;
end
legend('N = 25', 'N = 45', 'N = 65');
xlim([0, pi]);
xlabel('频率 (rad)');
ylabel('相对幅度 (dB)');
title('FIR 滤波器幅频特性（dB）');
grid on;
