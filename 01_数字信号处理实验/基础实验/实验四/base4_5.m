clear all;
wp=0.3;
ws=0.5;

deltaw = ws-wp;
filter_list = ["rectwin", "hann", "hamming", "triang", "blackman"];
N_exp_list = [4,6.2,6.6,8,11];

% ========== 防止中文乱码：设置中文字体 ==========
set(groot, 'defaultAxesFontName', 'SimHei');      % 黑体
set(groot, 'defaultTextFontName', 'SimHei');
set(groot, 'defaultLegendFontName', 'SimHei');

figure('Position', [100, 100, 1200, 800]);

for i = 1:5
    N0 = ceil(N_exp_list(i)/deltaw);
    N = N0+mod(N0+1,2);
    alfa = (N-1)/2;
    wc = (wp+ws)/2;
    
    switch i
        case 1
            windows = ones(N,1);
        case 2
            windows = hann(N);
        case 3
            windows = hamming(N);
        case 4
            windows = triang(N);
        case 5
            windows = blackman(N);
    end
    
    n = 0:N-1;
    hd = wc*sinc(wc*(n-alfa));
    h = hd.*windows';
    [H,w] = freqz(h,1,1024);
    
    subplot(2,3,i);
    H_norm = abs(H) / (abs(H(1)));
    plot(w/pi, 20*log10(H_norm), 'b', 'LineWidth', 1.5);
    
    xlim([0,1]);
    grid on;
    xlabel('频率 (×π rad/sample)');
    ylabel('幅度 (dB)');
    title(sprintf('低通滤波器 - %s (N=%d)', filter_list(i), N));
end

% ========== 保存 PDF，同时去除白边、防止乱码 ==========
% 方法1：使用 exportgraphics (推荐，R2020a 及以上)
% 先删除子图之间的多余空白，使整个图形紧凑 (可选)
set(gcf, 'Color', 'white');           % 背景白色
exportgraphics(gcf, '滤波器幅频响应.pdf', 'ContentType', 'vector');

% 方法2（若需要更大控制权，可取消注释）：
% set(gcf, 'PaperPositionMode', 'auto');
% print(gcf, '滤波器幅频响应.pdf', '-dpdf', '-fillpage');