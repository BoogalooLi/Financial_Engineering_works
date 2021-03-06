clc;
clear;
% format long;

K = csvread('500GSPC.csv', 1, 1);
n = size(K(:, 5), 1);

hold on
x = 1 : n;
y = K(:, 5);
plot(x, y, '-b', 'LineWidth', 2);
xlabel('Day');
ylabel('Adjusted closing price');
title('SP500 stock price form 3/1/2012 - 3/6/2013');

q = 2;

for i = 1 : n
    for j = 1 : q+1
        A(i, j) = x(i) ^ (q+1-j);
    end
end

alpha = Sherman_Morrison(A, y);


dx = (x(n) - x(1)) / n;
for j = 1:n
    xx(j) = dx * j;
    yy(j) = 0;
    for k = 1 : q+1
        yy(j) = yy(j) + alpha(k) * xx(j)^(q+1-k);
    end
end

plot(xx, yy, 'g-', 'LineWidth', 2);
L1Norm = norm((y-yy(1:n)'), 1);
L2Norm = norm((y-yy(1:n)'), 2);
LinfNorm = norm((y-yy(1:n)'), Inf);

fprintf('L1 Norm | %f\n degree | %d\n', L1Norm, q);
fprintf('L2 Norm | %f\n degree | %d\n', L2Norm, q);
fprintf('Linf Norm | %f\n degree | %d\n', LinfNorm, q);