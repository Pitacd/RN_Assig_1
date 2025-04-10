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

% Create New Features

nova_feature = X(:,4) ./ ((X(:,3) / 100).^2);
X = [nova_feature X];
VarNames = ['IMC' VarNames];

nova_feature = X(:,15) ./ (220 - X(:,2));
X = [nova_feature X];
VarNames = ['maxHeartR/HeartR' VarNames];

% Display histograms

figure(1);
subplot(2,2,1);
histogram(X(:, 3));
ylabel('Frequency');
xlabel('Age (y)');

figure(1);
subplot(2,2,2);
histogram(X(:, 16));
ylabel('Frequency');
xlabel('Heart rate (bpm)');

figure(1);
subplot(2,2,3:4);
histogram(X(:, 1));
ylabel('Frequency');
xlabel('Heart Rate Level');

figure(2);
subplot(2,2,1);
histogram(X(:, 5));
ylabel('Frequency');
xlabel('Height (cm)');

figure(2);
subplot(2,2,2);
histogram(X(:, 6));
ylabel('Frequency');
xlabel('Weigth (Kg)');

figure(2);
subplot(2,2,3:4);
histogram(X(:, 2));
ylabel('Frequency');
xlabel('IMC');
