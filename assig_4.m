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

% Before transformation
for i=1:20
    figure(1);
    subplot(4,5,i);
    histogram(X(:, i));
    title(VarNames(i));
    ylabel('Frequency');
    xlabel(VarNames(i));
end

% Apply transformation

% Apply zscore normalization
X(:, cols) = zscore(X(:, cols));

% Re-scale features
X(:, cols) = rescale(X(:, cols), 0 , 1);

% After transformation
for i=1:20
    figure(2);
    subplot(4,5,i);
    histogram(X(:, i));
    title(VarNames(i));
    ylabel('Frequency');
    xlabel(VarNames(i));
end
