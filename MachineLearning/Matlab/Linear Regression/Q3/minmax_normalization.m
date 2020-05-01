function [A_norm] = minmax_normalization(A)
%Q3
%   min-max normalization
for i = 1 : size(A, 1)
    A_norm(i, :) = (A(i, :) - min(A)) ./ (max(A) - min(A));
end

end

