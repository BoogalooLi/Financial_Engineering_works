clear;
clc;

Q3_2;

[m, ~] = size(Y);
f = [zeros(1, 5) ones(1, 2 * m)];

Aeq = [X eye(m) -eye(m)];
beq = Y;

lb = [-Inf(1, 5) zeros(1, 2 * m)];

x = linprog(f, [], [], Aeq, beq, lb, []);

beta_hat = x(1:5);