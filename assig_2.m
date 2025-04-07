clc;
clear;

load("arrhythmia.mat");

X_before = X;

% Number of missing values per column
missingCounts = sum(isnan(X), 1);  

% Display the number of columns with missing values
colsWithMissing = find(missingCounts > 0);

for i = 1:length(colsWithMissing)
    j = colsWithMissing(i);
    fprintf('Column %d has %d missing values.\n', j, missingCounts(j));
end

% Handle missing values

% Remove column 14
X(:,14) = [];

% Use mean imputation for col 11, col 12, col 13 and col 15
for i=11:15
    col = X(:,i);
    if any(isnan(col))
        X(:,i) = fillmissing(col, 'constant', mean(col(~isnan(col))));
    end
end

% Detect outliers 
outlierCounts = isoutlier(X);

% Normalize features
X = normalize(X, 'range');

figure(1);
subplot(1,2,1);
boxchart(X_before(:, 1:10));
title('Before Normalization');

subplot(1,2,2);
boxchart(X(:, 1:10));
title('After Normalization');