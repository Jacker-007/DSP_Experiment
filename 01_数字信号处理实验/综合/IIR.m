function [H_mag,bz,az] = IIR(fs,Low_jiezhi,High_jiezhi)
    T = 1/fs;
    Fp = Low_jiezhi;
    Fs = High_jiezhi;
    Rp = 1;
    As = 25;
    
    Wp = Fp/(fs/2);
    Ws = Fs/(fs/2);
    Wp_rad = Fp*2*pi/fs;
    Ws_rad = Fs*2*pi/fs;
    OmegaP = 2/T*tan(Wp_rad/2);
    OmegaS = 2/T*tan(Ws_rad/2);
    
    %% --- 双线性变换法幅频特性分析 ---
    [n,Wn] = buttord(OmegaP,OmegaS,Rp,As,'s');
    [b,a] = butter(n,Wn,'s');
    [bz,az] = bilinear(b,a,fs);
    fprintf('滤波器阶数 n = %d\n', n);
    [H,w] = freqz(bz,az,1024);
    H_mag = abs(H);
end