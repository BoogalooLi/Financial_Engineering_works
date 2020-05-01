function [X_train_norm,X_test_norm] = minmax_normalization(X_train,X_test)
%Q4_1
%   min-max normalization
for i = 1 : size(X_train, 1)
    X_train_norm(i, :) = (X_train(i, :) - min(X_train)) ./ (max(X_train) - min(X_train));
end


for i = 1 : size(X_test, 1)
    X_test_norm(i, :) = (X_test(i, :) - min(X_test)) ./ (max(X_test) - min(X_test));
end

end

