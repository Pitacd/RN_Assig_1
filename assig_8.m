clc 
clear

load("arrhythmia.mat");

X_original = X;

% --------//-----------

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

% --------//-----------

X_transformed = X;
X_new_features = X;

% --------//-----------

% Apply zscore normalization
X_transformed = zscore(X_transformed);

% Re-scale features
X_transformed = rescale(X_transformed, 0 , 1);

% Remove columns related to S' wave except 1
X_transformed(:, [31:12:151 , 164:10:274] ) = [];

% Remove column of DI Q wave amplitude (amplitude same corr as width)
X_transformed(:, 149 ) = [];

% Remove column of AVL QRSA (AVL same corr as DIII QRSA)
X_transformed(:, 190 ) = [];

% Join all the columns of figure 4 cause they are correlated
X_transformed(:, [18,19,63,65,78,107,122,123,129,131,133,135,140,146,151,249]) = [];

% Apply zscore normalization
X_transformed = zscore(X_transformed);

% Re-scale features
X_transformed = rescale(X_transformed, 0 , 1);

% --------//-----------

% Create New Features

nova_feature = X_new_features(:,4) ./ ((X_new_features(:,3) / 100).^2);
X_new_features = [nova_feature X_new_features];

nova_feature = X_new_features(:,15) ./ (220 - X_new_features(:,2));
X_new_features = [nova_feature X_new_features];

% --------//-----------

figure(1);
for i=1:6
    subplot(3,2,i);
    h1 = histogram(X_original(:,i), 'FaceColor', [0 0.4470 0.7410], 'FaceAlpha', 0.4);
    hold on;
    h2 = histogram(X_new_features(:,i+2), 'FaceColor', [0.4660 0.6740 0.1880], 'FaceAlpha', 0.4);
    ylabel('Frequency');
    xlabel(VarNames(i));
end

legend([h1 h2], {'Original (Blue)', 'New Features (Green)'}, 'Location', 'best');

figure(2);
for i=1:6
    subplot(3,2,i);
    h1 = histogram(X_transformed(:,i), 'FaceColor', [0.8500 0.3250 0.0980], 'FaceAlpha', 0.4);
    ylabel('Frequency');
    xlabel(VarNames(i));
end

legend([h1], {'Transformed (Red)'}, 'Location', 'best');


