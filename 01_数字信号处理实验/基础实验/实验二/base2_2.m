% 设置中文字体（黑体，保证导出 PDF 不乱码）
set(0, 'DefaultAxesFontName', 'SimHei');
set(0, 'DefaultTextFontName', 'SimHei');

clear all;
N = 8;
n = 0:N-1;
xc = [1:4,4:-1:1];     
xd = [4:-1:1,1:4];    
Xc = fft(xc,N);      
Xd = fft(xd,N); 

% 第一组图（三角/反三角）
figure(1);
subplot(3,2,1)
stem(n,xc);  title('三角波序列时域波形');    
subplot(3,2,3)
stem(n,abs(Xc));  title('三角波序列幅频特性|Xc(k)|');  
axis([0,8,0,10])
subplot(3,2,2)
stem(n,xd);  title('反三角波序列时域波形');   
subplot(3,2,4)
stem(n,abs(Xd));  title('反三角波序列幅频特性|xd(k)|');  
axis([0,8,0,10])
subplot(3,2,5);
stem(angle(Xc));  title('三角波序列相频特性');  
subplot(3,2,6)
stem(angle(Xd));  title('反三角波序列相频特性');  

% 导出第一个 PDF（无白边、矢量、中文正常）
exportgraphics(gcf, 'triangular_wave.pdf', 'ContentType', 'vector');

%% DTFT 部分
function Jw = my_dtft(x,N)
    Xn = length(x);
    Jw = zeros(1,N);
    w = linspace(0,2*pi,N);
    for k = 0:N-1
        for n = 0:Xn-1
            Jw(k+1) = Jw(k+1) + x(n+1)*exp(-1j*w(k+1)*n);
        end
    end
end

% 第二组图（DTFT）
figure(2);
N = 1024;
w = linspace(0,2*pi,N);
Xc_jw = my_dtft(xc,N);
Xd_jw = my_dtft(xd,N);

subplot(2,1,1);
plot(w,abs(Xc_jw),"LineStyle","-","Color","r","LineWidth",1.5);
xlim([0,2*pi]);
title('三角波序幅频特性');

subplot(2,1,2);
plot(w,abs(Xd_jw),"LineStyle","-","Color","r","LineWidth",1.5);
xlim([0,2*pi]);
title('反三角波序幅频特性');

% 导出第二个 PDF
exportgraphics(gcf, 'dtft_result.pdf', 'ContentType', 'vector');