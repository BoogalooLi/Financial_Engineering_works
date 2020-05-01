clear;
clc;

[Y, X] = get_data();

% \
beta = (X' * X) \ (X' * Y);

% chol()
R = chol(X' * X);
beta_chol = (R' * R) \ (X' * Y);

% qr()
[Q, RR] = qr(X' * X);
beta_qr = (Q * RR) \ (X' * Y);

% svd()
[U, S, V] = svd(X' * X);
beta_svd = (U * S * V') \ (X' * Y);

% pinv()
beta_pinv = pinv(X' * X) * (X' * Y);


