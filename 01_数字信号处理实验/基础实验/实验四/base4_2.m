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

%%
sin_freqLab = [50, 125, 200];
Fs = 1000;
Ts = 1/Fs;
L = 500;
t = (0:L-1) * Ts;
y = zeros(3, L);

% 创建图形窗口，固定大小（宽8英寸，高7英寸，适合三个子图）
figure('Units', 'inches', 'Position', [1, 1, 8, 7]);

for i = 1:3
    x = sin(2*pi*sin_freqLab(i)*t);
    y(i,:) = filter(h, 1, x);
    subplot(3, 1, i);
    % 左纵轴：输入信号（红色）
    yyaxis left
    plot(t, x, 'r-', 'LineWidth', 1);
    ylabel('输入幅度', 'Color', 'r');
    set(gca, 'YColor', 'r');
    ylim([-1, 2]);
    
    % 右纵轴：输出信号（蓝色）
    yyaxis right
    plot(t, y(i,:), 'b-', 'LineWidth', 1);
    ylabel('输出幅度', 'Color', 'b');
    set(gca, 'YColor', 'b');
    ylim([-1, 2]);
    
    % 标题和 x 轴（共用）
    title(sprintf('%d Hz 正弦波', sin_freqLab(i)));
    xlabel('时间 (s)');
    xlim([0 0.05]);
    grid on;
    
    legend('输入', '输出', 'Location', 'northeast');
end

sgtitle('FIR 低通滤波器对正弦波的滤波效果');
