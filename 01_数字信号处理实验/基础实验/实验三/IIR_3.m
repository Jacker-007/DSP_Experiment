clear all;
Fs = 1000;
Ts = 1/Fs;
Fp = 100;
Fst = 175;
Ap = 1;
Ast = 15;

Wp = Fp/(Fs/2);
Wst = Fst/(Fs/2);

[n, Wn] = buttord(Wp, Wst, Ap, Ast);
[b, a] = butter(n, Wn);

Fs_list = [150, 500, 1000];
sin_freq = 60;
N = 5000;              
% 创建图形窗口，固定大小（宽8英寸，高6英寸，适合3个子图垂直排列）
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

for i = 1:length(Fs_list)
   Ts = 1/Fs_list(i);
   t = (0:N-1)*Ts; 
   x = sin(2*pi*sin_freq*t);
   y = filter(b,a,x);

   fc_actual = Wn * Fs_list(i)/2;

   subplot(3, 1, i);
   plot(t*1000, x, 'b', 'LineWidth', 1);
   hold on;
   plot(t*1000, y, 'r', 'LineWidth', 1.5);
   xlabel('时间 (ms)');
   ylabel('幅度');
   title(sprintf('Fs=%.0fHz, 等效截止频率 fc=%.0fHz', Fs_list(i), fc_actual));
   legend('输入', '输出');
   grid on;
   xlim([0 50]);
end
sgtitle('不同采样率下60Hz正弦波通过巴特沃斯滤波器的响应');
