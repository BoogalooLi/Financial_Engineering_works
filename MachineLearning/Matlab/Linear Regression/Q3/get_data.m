function [Y_norm, X_norm] = get_data()
%Q3
%   read the data in csv file and normalize the data for using
A = csvread('500GSPC.csv', 1, 1);

Y = A(:, 4);
X = [A(:, 1), A(:, 2), A(:, 3), A(:, 6)];

Y_norm = minmax_normalization(Y);
X_norm = [ones(length(Y_norm), 1), minmax_normalization(X)];

end

