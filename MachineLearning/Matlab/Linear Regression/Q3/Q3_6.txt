clear;
clc;
Q3_2;

% using z score to normalize data
A = csvread('500GSPC.csv', 1, 1);

Y = A(:, 4);
X = [A(:, 1), A(:, 2), A(:, 3), A(:, 6)];

x = zscore(X);
y = zscore(Y);
x = [ones(size(x, 1), 1) x];

beta_z = (x'*x) \ (x'*y);

y_hat = x * beta_z;

residual_z = norm((y - y_hat), 2);
residual_ba = norm((Y - Y_ba), 2); % this is the resudual in part 2

function [z] = zscore(A)
%Q3
%   min-max normalization
for i = 1 : size(A, 1)
    z(i, :) = (A(i, :) - mean(A)) ./ std(A);
end

end
