clear all;
a = [1,-2,1];
b = [0,1];

N = 32;
x = zeros(1,N);
y = zeros(1,N);
x(1) = 1;

for n = 1:N
    y(n) = b(1)*x(n);
    if n>=2
        y(n) = y(n) + b(2)*x(n-1);
        y(n) = y(n) - a(2)*y(n-1);
    end
    if n>=3
        y(n) = y(n) - a(3)*y(n-2);
    end
end

figure;
stem(0:N-1,y,'LineWidth',1.5);
title("单位脉冲响应");
ylabel("幅值");
xlabel("n");
figure;
[h_zero,h_pole,h_uint] = zplane(b,a);
% legend([h_zero,h_pole,h_uint],{"零点","极点","单位圆"},"location","northeast");
ylabel("虚部");
title("零级图");