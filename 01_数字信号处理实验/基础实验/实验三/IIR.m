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

%% 幅频特性和相频特性分析

% 计算频率响应
[H, w] = freqz(b, a, 1024);  % H是复数频率响应，w是对应的频率点
mag = abs(H);                      % 幅值
phase = angle(H);                  % 相位（弧度）
mag_dB = 20*log10(mag);            % 幅值（dB）

% 创建图形窗口，固定大小（单位：英寸，宽6高8）
figure('Units', 'inches', 'Position', [1, 1, 6, 8]);

% 子图1：幅频特性
subplot(3,1,1);
plot(w, mag, 'b-', 'LineWidth', 1.5);
grid on;
xlabel('\omega');
ylabel('幅值 |H(e^{j\omega})|');
title('幅频特性');
xlim([0, pi]);
line([Wp*pi, Wp*pi], [0, 1], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1);
line([Wst*pi, Wst*pi], [0, 1], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1);

% 子图2：幅频特性（dB坐标）
subplot(3,1,2);
plot(w, mag_dB, 'r-', 'LineWidth', 1.5);
grid on;
xlabel('\omega');
ylabel('幅值 (dB)');
title('幅频特性（dB坐标）');
xlim([0, pi]);
ylim([-80, 0]);

% 在图上标记通带和阻带
hold on;
line([0,pi],[-1,-1],'linestyle','--');
line([0,pi],[-15,-15],'linestyle','--');
line([Wp*pi, Wp*pi], [-80, 0], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1);
line([Wst*pi, Wst*pi], [-80, 0], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1);

% 子图3：相频特性
subplot(3,1,3);
plot(w, phase*180/pi, 'g-', 'LineWidth', 1.5);
grid on;
xlabel('\omega');
ylabel('相位 (度)');
title('相频特性');
xlim([0, pi]);
ylim([-180,180]);
line([Wp*pi, Wp*pi], [-180, 180], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1);
line([Wst*pi, Wst*pi], [-180, 180], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1);

% 总标题
sgtitle('巴特沃斯数字低通滤波器特性分析');
