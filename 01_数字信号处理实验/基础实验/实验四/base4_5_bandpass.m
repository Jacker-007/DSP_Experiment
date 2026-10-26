clear all;
w1=0.3;
w2=0.5;

deltaw = 0.1;
filter_list = ["rectwin", "hann", "hamming", "triang", "blackman"];
N_exp_list = [4,6.2,6.6,8,11];

figure('Position', [100, 100, 1200, 800]);

for i = 1:5
    N0 = ceil(N_exp_list(i)/deltaw);
    N = N0+mod(N0+1,2);
    alfa = (N-1)/2;

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
    hd1 = w1*sinc(w1*(n-alfa));
    hd2 = w2*sinc(w2*(n-alfa));
    hd = hd2-hd1;
    h = hd.*windows';
    [H,w] = freqz(h,1,1024);
    
    subplot(2,3,i);
    H_norm = abs(H) / max(abs(H));
    plot(w/pi, 20*log10(H_norm), 'b', 'LineWidth', 1.5);
    ylim([-80, 5]);
    grid on;
    xlabel('频率 (×π rad/sample)');
    ylabel('幅度 (dB)');
    title(sprintf('带通滤波器 - %s (N=%d)', filter_list(i), N));
end