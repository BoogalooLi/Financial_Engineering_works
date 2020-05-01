clear;
clc;

% load data of housing dataset
load('housedata.mat');

% Xtrain, ytrain are randomly split train data.
% Xtrain, ytest are randomly split test data.
% The task is to predict the median house value from features
% describing a town.

% Normalize the features
[X_train_norm, X_test_norm] = minmax_normalization(Xtrain, Xtest);

% because values of Y range in real numbers, it is better to normalize to
% understand RMSE errors

[Y_train_norm, Y_test_norm] = minmax_normalization(ytrain, ytest);

% generate polynomial features from k = 1 to k = 5;
% k=degree of polynomial and train 5 different linear regressors with
% these features
% find RMSE of train and test data

rmseTrain = zeros(5, 1);
rmseTest = zeros(5, 1);

lambda = 1;

for k = 1 : 5
    X_poly_train = polynomial_regression(X_train_norm, k);
    X_poly_test = polynomial_regression(X_test_norm, k);
    [w, w_0] = train_ridge(X_poly_train, Y_train_norm, lambda,1);

    rmseTrain(k,:) = norm((Y_train_norm -  X_poly_train * w - w_0), 2);
    rmseTest(k,:) = norm((Y_test_norm -  X_poly_test * w - w_0), 2);
end

plot(rmseTrain);
hold on;
plot(rmseTest);
xlabel('Degree of the polynomial function');
ylabel('L^2 norm error');
legend('Training error', 'Test error');
hold off;