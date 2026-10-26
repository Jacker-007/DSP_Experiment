clear all;
wp=0.3*pi;
ws=0.5*pi;

deltaw = ws-wp;
filter_list = ["rectwin", "hann", "hamming", "triang", "blackman"];
N_exp_list = [4,6.2,6.6,8,11];

figure('Name', '窗函数对比', 'Position', [100 100 1200 800]);

for i = 1:5
    N0 = ceil(N_exp_list(i)*pi/deltaw);
    N = N0+mod(N0+1,2)+1;
    wc = (wp+ws)/2/pi;
    win = window(str2func(filter_list(i)), N+1);
    b = fir1(N,wc,"high",win);

    [H, w] = freqz(b, 1, 1024);

    subplot(2,3,i);
    plot(w,20*log10(abs(H)/max(abs(H))),'LineStyle','-','Color','b','LineWidth',1.5);
    grid on;
    axis([0, pi, -100, 5]);
    title(filter_list(i), 'FontSize', 12);
    xlabel('\omega');
    ylabel('幅度 (dB)');
end





