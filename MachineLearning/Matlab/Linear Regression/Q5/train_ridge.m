function [w,w_0] = train_ridge(X, y, lambda,bias)
%train_ridge
%   Q5_2

[NumofSamples, ~] = size(X);

if bias == 1
    col = ones(NumofSamples, 1);
    X = [X col];
    X = X';
end

[m, ~] = size(X);

I = eye(m);
w = (X * X' + lambda * I) \ (X * y);


if bias == 0
    w_0 = 0;
else
    w_0 = w(end);
    w(end) = [];
end

end

