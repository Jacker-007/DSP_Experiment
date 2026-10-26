clear all;
T = 0.001;
F = 1/T;
Fp = 200;
Fs = 300;
Rp = 1;
As = 25;

Wp = Fp/(F/2);
Ws = Fs/(F/2);
Wp_rad = Fp*2*pi/F;
Ws_rad = Fs*2*pi/F;
OmegaP = 2/T*tan(Wp_rad/2);
OmegaS = 2/T*tan(Ws_rad/2);

%% --- 双线性变换法幅频特性分析 ---
[n,Wn] = buttord(OmegaP,OmegaS,Rp,As,'s');
[b,a] = butter(n,Wn,'s');
[bz,az] = bilinear(b,a,F);

[H,w] = freqz(bz,az,1024);
mag = abs(H);

fprintf('3dB截止频率 Wn = %.4f rad/s (%.2f Hz)\n', Wn, Wn/(2*pi));

%% 冲激响应不变法
Wp_analog = 2*pi*Fp;   % 通带角频率 (rad/s)
Ws_analog = 2*pi*Fs;   % 阻带角频率 (rad/s)

[n_imp, Wn_analog] = buttord(Wp_analog, Ws_analog, Rp, As, 's');
[bs, as] = butter(n_imp, Wn_analog, 's');
[b_imp, a_imp] = impinvar(bs, as, F);

[H1,w] = freqz(b_imp,a_imp,1024);
mag1 = abs(H1);

fprintf('3dB截止频率 Wn = %.4f rad/s (%.2f Hz)\n', Wn_analog, Wn_analog/(2*pi));

%% 合并绘图：一个 figure 两个子图
figure('Units', 'inches', 'Position', [1, 1, 8, 4]);

% 子图1：线性幅度特性
subplot(1,2,1);
hold on;
plot(w, mag, 'b-', 'LineWidth', 0.5, 'DisplayName', '双线性变换');
plot(w, mag1, 'r-', 'LineWidth', 0.5, 'DisplayName', '冲激响应不变');
xlim([0, pi]);
ylim([0, 1]);
line([Wp*pi, Wp*pi], [0, 1], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1, 'DisplayName', '通带截止频率');
line([Ws*pi, Ws*pi], [0, 1], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1, 'DisplayName', '阻带截止频率');
line([0, pi], [10^(-Rp/20), 10^(-Rp/20)], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1, 'HandleVisibility', 'off');
line([0, pi], [10^(-As/20), 10^(-As/20)], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1, 'HandleVisibility', 'off');
grid on;
xlabel('频率 \omega (rad)');
ylabel('幅值 |H(e^{j\omega})|');
title('幅频特性（线性）');
legend('Location', 'northeast');

% 子图2：dB 幅度特性
subplot(1,2,2);
hold on;
plot(w, 20*log10(mag), 'b-', 'LineWidth', 0.5, 'DisplayName', '双线性变换');
plot(w, 20*log10(mag1), 'r-', 'LineWidth', 0.5, 'DisplayName', '冲激响应不变');
xlim([0, pi]);
ylim([-100, 0]);
line([Wp*pi, Wp*pi], [-100, 0], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1, 'DisplayName', '通带截止频率');
line([Ws*pi, Ws*pi], [-100, 0], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1, 'DisplayName', '阻带截止频率');
line([0, pi], [-Rp, -Rp], 'Color', 'g', 'LineStyle', '--', 'LineWidth', 1, 'HandleVisibility', 'off');
line([0, pi], [-As, -As], 'Color', 'm', 'LineStyle', '--', 'LineWidth', 1, 'HandleVisibility', 'off');
grid on;
xlabel('频率 \omega (rad)');
ylabel('幅值 (dB)');
title('幅频特性（dB）');
legend('Location', 'southwest');

% 总标题（可选）
sgtitle('巴特沃斯数字滤波器设计：双线性变换 vs 冲激响应不变法');
