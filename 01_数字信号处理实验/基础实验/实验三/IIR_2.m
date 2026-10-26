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

%% 滤波器对不同频率的正弦波信号进行滤波
figure('Units', 'inches', 'Position', [1, 1, 8, 6]);

f_pass = 50;       
f_trans = 130;      % 过渡带内（100-175Hz）
f_stop = 300;  
f_test = [f_pass, f_trans, f_stop];

N = 500;              
t = (0:N-1)*Ts; 
gain = zeros(1,3);

for i = 1:3
    x = sin(2*pi*f_test(i)*t);
    y = filter(b,a,x);

    gain(i) = max(abs(y))/max(abs(x));
    subplot(3, 1, i);
    plot(t*1000, x, 'b', 'LineWidth', 1);
    hold on;
    plot(t*1000, y, 'r', 'LineWidth', 1.5);
    xlabel('时间 (ms)');
    ylabel('幅度');
    % 子图标题：显示正弦波频率
    title(sprintf('输入正弦波频率 = %.0f Hz', f_test(i)));
    legend('输入', '输出');
    grid on;
    xlim([50 100]);
end

sgtitle('巴特沃斯滤波器对不同频率正弦波的滤波效果');
