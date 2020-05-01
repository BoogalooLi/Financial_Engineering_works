clc;
clear;

Q3_2;

beta_hat = zeros(5, 1);
count = 0;
eta = 0.001 ; % 100 10 1 0.1 0.01
eps = 0.00001;

tmp = eta * X' * (Y_ba - X_ba * beta_hat);


while ~condition_function(tmp)
    beta_hat = beta_hat + tmp;
    count = count + 1;
    tmp = eta * X' * (Y_ba - X_ba * beta_hat);
end

function result = condition_function(tmp)
    result = true;
    for i = 1 : 5
        a = abs(tmp(i)) < eps;
        result = a & result;
    end
end



    

