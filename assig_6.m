clc
clear 

load ("arrhythmia.mat");

% --------//-----------

% Do Task 2 and 4

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

% Apply zscore normalization
X= zscore(X);

% Re-scale features
X = rescale(X, 0 , 1);

% --------//-----------

% Do Task 5

% Remove columns related to S' wave except 1
X(:, [31:12:151 , 164:10:274] ) = [];
VarNames(:, [31:12:151 , 164:10:274] ) = [];

% Remove column of DI Q wave amplitude (amplitude same corr as width)
X(:, 149 ) = [];
VarNames(:,149) = [];

% Remove column of AVL QRSA (AVL same corr as DIII QRSA)
X(:, 190 ) = [];
VarNames(:,190) = [];

% Join all the columns of figure 4 cause they are correlated
X(:, [18,19,63,65,78,107,122,123,129,131,133,135,140,146,151,249]) = [];
VarNames(:,[18,19,63,65,78,107,122,123,129,131,133,135,140,146,151,249]) = [];

% --------//-----------