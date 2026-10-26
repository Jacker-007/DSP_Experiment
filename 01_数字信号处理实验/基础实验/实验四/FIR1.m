clear all; close all;

wp = 0.2;        % 通带截止（归一化，对应0.2π）
ws = 0.35;       % 阻带截止（归一化，对应0.35π）

deltaw = ws - wp;
N = ceil(6.6/deltaw);      
N = N + mod(N+1, 2);        
wc = (wp + ws)/2;            % 截止频率取中点
b = fir1(N-1, wc);          

[H, w] = freqz(b, 1, 512);

%% 5. 作图
% 图1：实际冲激响应（不是"理想"的，理想的是无限长sinc）
subplot(3,1,1);
stem(0:length(b)-1, b, 'filled');
title('实际冲激响应 h(n)'); xlabel('n'); ylabel('h(n)');
axis([0, length(b)-1, min(b)-0.05, max(b)+0.05]);

% 图2：幅度特性（dB）
subplot(3,1,2);
plot(w/pi, 20*log10(abs(H)));
axis([0, 1, -100, 5]);
title('幅度特性'); xlabel('\omega/\pi'); ylabel('|H(\omega)| (dB)');
grid on;

% 图3：相位特性（unwrap后看线性）
subplot(3,1,3);
plot(w/pi, angle(H)/pi);
title('相位特性（已解卷绕）'); xlabel('\omega/\pi'); ylabel('相位/\pi');
grid on;