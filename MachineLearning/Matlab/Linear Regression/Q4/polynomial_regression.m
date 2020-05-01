function [X_poly] = polynomial_regression(X,k)
%Q4_2
%   polynomial_regression
%   I have tried my best but I cannot fill the function in one line.
if k == 1
    X_poly = [X];
else
    X_poly = [X.^k polynomial_regression(X, k-1)]; 
end

