% 设置中文字体（防止导出 PDF 乱码）
set(0, 'DefaultAxesFontName', 'SimHei');
set(0, 'DefaultTextFontName', 'SimHei');

clear all;

F = 50;
N = [32, 32, 32, 32, 64];
T = [0.000625, 0.005, 0.00046875, 0.004, 0.000625];   % 修正第3个T为0.00046875（原书可能笔误）
label = {'F=50, N=32, T=0.000625';
         'F=50, N=32, T=0.005';
         'F=50, N=32, T=0.00046875';
         'F=50, N=32, T=0.004';
         'F=50, N=64, T=0.000625'};

figure(1);
for m = 1:5
    n = 0:N(m)-1;                % 修正：应该从0到N-1，共N个点
    xn = cos(2*pi*F*T(m) * n);   % 修正点乘
    Xk = fft(xn);
    subplot(5,1,m);
    stem(n, abs(Xk));
    title(label(m));
end

% 导出为 PDF（无白边、矢量、中文正常）
exportgraphics(gcf, 'fft_analysis.pdf', 'ContentType', 'vector');