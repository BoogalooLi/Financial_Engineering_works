function [w_SM] = Sherman_Morrison(X, y)
%Q2_3
%   Sherman_Morrison and iteration-OLS

format long;
[m, n]=size(X);

beta = rand(n, 1);
I = eye(n);
P = I * 10^5; % a big number here, need testing for better initial value

for k = 1 : m 
    Xk = X(k, :); 
    Q1 = P * (Xk'); 
    Q2 = 1 + Xk * P * (Xk'); 
    K = Q1/Q2;   
    beta = beta + K * (y(k) - Xk * beta);  
    P = (I - K * Xk) * P;    
    theta(:, k) = beta;   
    steps(k) = k;     
end

steps = steps';
w_SM=theta(:,end);
end
