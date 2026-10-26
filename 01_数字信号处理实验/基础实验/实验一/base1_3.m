function y = my_conv(x1,x2)
    N1 = length(x1);
    N2 = length(x2);
    Ny = N1 + N2 -1;
    y = zeros(1,Ny);
    for n = 0:Ny-1
        for k = max(n-(N2-1),0):min(N1-1,n)
            y(n+1) = y(n+1) + x1(k+1) * x2(n-k+1);
        end
    end
end

clear all;
n = 0:9; a = 1;b = 3/4;
x = a.^n;
n = 0:49;
h = b.^n;
        
y1 = my_conv(x,h);
y2 = conv(x,h);

subplot(4,1,1)   
stem([0:length(x)-1],x);         
xlabel('n'); ylabel('幅度'); title('x');
axis([0,49,0,2]);
subplot(4,1,2)
stem([0:length(h)-1],h);           
xlabel('n'); ylabel('幅度'); title('h');
axis([0,49,0,2]);
subplot(4,1,3)
stem([0:length(y1)-1],y1);         
xlabel('n'); ylabel('幅度'); title('我的线性卷积');
axis([0,49,0,4]);
subplot(4,1,4)
stem([0:length(y2)-1],y2);            %线性卷积结果图像
xlabel('n'); ylabel('幅度'); title('自带的线性卷积');
axis([0,49,0,4]);