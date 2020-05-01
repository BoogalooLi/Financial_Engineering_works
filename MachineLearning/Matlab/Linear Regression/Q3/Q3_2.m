clc;
clear;

[Y, X] = get_data();

beta = (X' * X) \ (X' * Y);

Y_ba = X * beta - mean(Y) * ones(length(Y), 1);
[m, n] = size(X);
X_ba = X - mean(X) .* ones(m, n);
X_ba(:, 1) = ones(m, 1);

beta_ba = (X_ba' * X_ba) \ (X_ba' * Y_ba);