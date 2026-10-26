function [H_mag,h] = FIR(fs,str,Low_jiezhi,High_jiezhi)
    T = 1/fs;
    class(str);
    str = string(str);
    Fp = Low_jiezhi;
    Fs = High_jiezhi;
    
    wp = Fp/(fs/2);
    ws = Fs/(fs/2);

    deltaw = ws-wp;
    
    filter_list = ["rectwin", "hann", "hamming", "triang", "blackman"];
    N_exp_list = [4,6.2,6.6,8,11];
    i = find(strcmp(filter_list, str));
    N0 = ceil(N_exp_list(i)/deltaw);
    N = N0+mod(N0+1,2);
    fprintf('滤波器阶数 N = %d\n', N);
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
    H_mag = abs(H);
end


