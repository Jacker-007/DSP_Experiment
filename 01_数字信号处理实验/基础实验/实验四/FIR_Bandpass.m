clear all;
wp1 = 0.4;
wp2 = 0.6;
ws1 = 0.2;
ws2 = 0.7;

deltaw = min((wp1-ws1),(ws2-wp2));
N0 = ceil(6.6/deltaw);
N = N0 + mod(N0+1,2);
alpha = (N-1)/2;
wc1 = (wp1 + ws1)/2;
wc2 = (wp2 + ws2)/2;
n = 0:N-1;
h1 = wc1*sinc(wc1*(n-alpha));
h2 = wc2*sinc(wc2*(n-alpha));
hd = h2-h1;
windows = hamming(N);

h = hd.*windows.';
[H,w] = freqz(h,1);
subplot(2,1,1);plot(w/pi,20*log10(abs(H)/max(abs(H))));  %幅度特性(dB)
axis([0,1,-100,10]); title('FIR滤波器幅度特性');ylabel('H(dB)');
subplot(2,1,2);plot(w/pi,angle(H)/pi); title('FIR滤波器相位特性'); ylabel('pha'); %相位特性
