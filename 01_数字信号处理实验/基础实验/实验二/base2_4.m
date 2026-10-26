function X = my_dft(x)
    N = length(x);
    X = zeros(1,N);
    k = (0:N-1).';
    n = 0:N-1;
    Wk = exp(-1j*2*(pi/N)*(k*n));
    X1 = Wk*(x.');
    X = X1;
end

N = 64;
n = 0:N-1;
a = 0.5;
x = a.^n;

tic,
disp('快速傅里叶变换时间：')
y1 = fft(x);
toc

tic,
disp('离散傅里叶变换时间：')
y2 = my_dft(x);
toc