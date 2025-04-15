clc;
clear;

load("arrhythmia.mat");

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

X_before = X;
cols = [1, 3:20, 27:32, 39:44, 51:56, 63:68, 75:80, 87:92, 99:104, 111:116, 123:128, 135:140, 147:152, 159:278];

% --- Number of Outliers Before ---
outliers_before = isoutlier(X_before(:,cols));
outliers_before_count = sum(outliers_before, 1);

% Replace outliers of continous types columns with the nearest non-outlier
X(:, cols) = filloutliers(X(:,cols), "linear", "mean");

% Re-scale features
X(:, cols) = rescale(X(:, cols), 0, 1);

% --- Number of Outliers After ---
outliers_after = isoutlier(X(:,cols));
outliers_after_count = sum(outliers_after, 1);

% Create a table to compare the outliers
outlierTable = table(cols', outliers_before_count', outliers_after_count', ...
    'VariableNames', {'Column', 'Outliers_Before', 'Outliers_After'});

% Display Before and After the first 10 columns
figure(1);
subplot(1,2,1);
boxchart(X_before(:, 1:10));
title('Before Cleaning');
xlabel('Column');
ylabel('Frequency');


subplot(1,2,2);
boxchart(X(:, 1:10));
title('After Cleaning');
xlabel('Column');
ylabel('Frequency');

% Display table to compare the outliers
figure(2);
uitable('Data', outlierTable{:,:}, ...
    'ColumnName', outlierTable.Properties.VariableNames, ...
    'RowName', [], ...
    'Units', 'normalized', ...
    'Position', [0 0 1 1]);

% Display the total of outliers before and after 
disp(sum(outliers_before_count));
disp(sum(outliers_after_count));
