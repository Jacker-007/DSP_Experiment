 function X = my_dft(x)
    N = length(x);
    X = zeros(1,N);
    k = (0:N-1).';
    n = 0:N-1;
    Wk = exp(-1j*2*(pi/N)*(k*n));
    X = Wk*(x.');
end

clear all;
N = 8; a = 0.7;
n = 0:N-1;
x = a.^n;
X = my_dft(x);

subplot(3,1,1)
stem(n,x,'.k'); axis([0,8,0,1.5])    
title('x(n) a=0.7');
subplot(3,1,2)
stem(n,abs(X),'.k'); axis([0,8,0,5])                 %幅度特性
title('X(k)幅度');
subplot(3,1,3)
stem(n,angle(X),'.k'); axis([0,8,-1.5,1.5])          %相位特性
title('X(k)相位');
