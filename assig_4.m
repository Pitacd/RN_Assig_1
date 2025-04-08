clc;
clear;
load("arrhythmia.mat");

% Remove column 14
X(:,14) = [];
VarNames(14) = [];

% Use mean imputation for col 11, col 12, col 13 and col 15
for i=11:15
    col = X(:,i);
    if any(isnan(col))
        X(:,i) = fillmissing(col, 'constant', mean(col(~isnan(col))));
    end
end

% Replace outliers of continous types columns with the nearest non-outlier
cols = [1, 3:20, 27:32, 39:44, 51:56, 63:68, 75:80, 87:92, 99:104, 111:116, 123:128, 135:140, 147:152, 159:278];
X(:, cols) = filloutliers(X(:,cols), "linear", "mean");

% Normalize features
X = normalize(X, 'range');

% Apply z-score normalization
X_before=X;
[X, mu, sigma] = zscore(X);

% Show before and after z-score normaloization
figure(1);
subplot(1,2,1);
boxchart(X_before(:, 1:10));
title('Before z-score');

subplot(1,2,2);
boxchart(X(:, 1:10));
title('After z-score');
