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

% Replace outliers of continous types columns with the nearest non-outlier
X(:,1) = filloutliers(X(:,1), 'nearest');
X(:, 3:20) = filloutliers(X(:, 3:20), 'nearest');
X(:, 26:32) = filloutliers(X(:, 26:32), 'nearest');
X(:, 39:44) = filloutliers(X(:, 39:44), 'nearest');
X(:, 51:56) = filloutliers(X(:, 51:56), 'nearest');
X(:, 63:68) = filloutliers(X(:, 63:68), 'nearest');
X(:, 75:80) = filloutliers(X(:, 75:80), 'nearest');
X(:, 87:92) = filloutliers(X(:, 87:92), 'nearest');
X(:, 99:104) = filloutliers(X(:, 99:104), 'nearest');
X(:, 111:116) = filloutliers(X(:, 111:116), 'nearest');
X(:, 123:128) = filloutliers(X(:, 123:128), 'nearest');
X(:, 135:140) = filloutliers(X(:, 135:140), 'nearest');
X(:, 147:152) = filloutliers(X(:, 147:152), 'nearest');
X(:, 159:278) = filloutliers(X(:, 159:278), 'nearest');

% Normalize features
X = normalize(X, 'range');

% Display Before and After the first 10 columns
figure(1);
subplot(1,2,1);
boxchart(X_before(:, 1:10));
title('Before Cleaning');

subplot(1,2,2);
boxchart(X(:, 1:10));
title('After Cleaning');