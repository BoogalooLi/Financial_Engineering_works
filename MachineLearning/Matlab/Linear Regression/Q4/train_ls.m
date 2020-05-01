function [w,w_0] = train_ls(X, y, bias)
%train_ls
%   Q2_1

[NumofSamples, ~] = size(X);

if bias == 1
    col = ones(NumofSamples, 1);
    X = [X col];
end

[U, S, V] = svd(X' * X);
w = (U * S * V') \ (X' * y);

if bias == 0
    w_0 = 0;
else
    w_0 = w(end);
    w(end) = [];
end

end

