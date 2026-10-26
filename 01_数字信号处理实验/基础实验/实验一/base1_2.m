clear all;
b=[0.0181,0.0543,0.0543,0.0181];
a=[1.000,-1.76,1.1829,-0.2781];

N = 1024;
n = 32;

[H,w] = freqz(b,a,N);
mag = abs(H);
phase = angle(H);
omega = w/pi;
subplot(3,1,1);
h=impz(b,a,n);
stem(0:length(h)-1,h,'filled'); title('冲激响应h(n)');
subplot(3,1,2);
plot(w,mag,"LineStyle","-","Color","r","LineWidth",1.5);
title('幅度响应');
ylabel('|H|');
xlim([0,pi]);
subplot(3,1,3);
plot(w,phase,"LineStyle","-","Color","b","LineWidth",1.5);
xlim([0,pi]);
title('相位响应');
ylabel('angle(H)');

