function y_CovFast = FastConv(x, h)
    Nx = length(x);
    Nh = length(h);
    N = Nx + Nh - 1;
    X = fft(x, N);
    H = fft(h, N);
    Y = X .* H;
    y_CovFast = ifft(Y, N);
end

clear; close all;

%% 第一组实验
n1 = 0:13;
a1 = 1; b1 = 4/5;
x1 = a1 .^ n1;
h1 = b1 .^ n1;
y1 = FastConv(x1, h1);

%% 第二组实验
n_x2 = 0:9;
a2 = 1;
x2 = a2 .^ n_x2;
n_h2 = 0:19;
h2 = 0.5 * sin(0.5 * n_h2);
y2 = FastConv(x2, h2);

%% 第三组实验
n3 = 0:9;
a3 = 1; b3 = 0.1;
x3 = a3 .^ n3 - b3 * n3;
h3 = b3 * n3;
y3 = FastConv(x3, h3);

%% 绘图
figure;


% 第一行
subplot(3,3,1)
stem(n1, x1, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验1: x(n) = 1'); xlabel('n'); ylabel('x(n)'); grid on

subplot(3,3,2)
stem(n1, h1, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验1: h(n) = (4/5)^n'); xlabel('n'); ylabel('h(n)'); grid on

subplot(3,3,3)
stem(0:length(y1)-1, y1, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验1: 卷积结果 (FFT)'); xlabel('n'); ylabel('y(n)'); grid on

% 第二行
subplot(3,3,4)
stem(n_x2, x2, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验2: x(n) = 1'); xlabel('n'); ylabel('x(n)'); grid on

subplot(3,3,5)
stem(n_h2, h2, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验2: h(n) = 0.5 sin(0.5n)'); xlabel('n'); ylabel('h(n)'); grid on

subplot(3,3,6)
stem(0:length(y2)-1, y2, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验2: 卷积结果 (FFT)'); xlabel('n'); ylabel('y(n)'); grid on

% 第三行
subplot(3,3,7)
stem(n3, x3, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验3: x(n) = 1 - 0.1n'); xlabel('n'); ylabel('x(n)'); grid on

subplot(3,3,8)
stem(n3, h3, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验3: h(n) = 0.1n'); xlabel('n'); ylabel('h(n)'); grid on

subplot(3,3,9)
stem(0:length(y3)-1, y3, 'filled', 'LineWidth', 0.5, 'MarkerSize', 4)
title('实验3: 卷积结果 (FFT)'); xlabel('n'); ylabel('y(n)'); grid on
