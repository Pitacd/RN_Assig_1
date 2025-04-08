clc 
clear

load('arrhythmia.mat');

% --------//-----------

% Do Task 2

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

% --------//-----------

% Visualize features

% HISTOGRAMS

% Age 
figure(1);
subplot(3,1,1);
histogram(X(:, 1));
title('Age');
ylabel('Frequency');
xlabel('Age (y)');

% Sex 
figure(1);
subplot(3,1,2);
histogram(X(:, 2));
title('Sex');
ylabel('Frequency');
xlabel('Sex (0-male, 1-female)');

% Heart Rate 
figure(1);
subplot(3,1,3);
histogram(X(:, 14)); 
title('Heart Rate');
xlabel('Beats (per min)');
ylabel('Frequency');

% BOXCHARTS

% Function to display two figures with boxchart graphs of each channel
% average wave width
function boxChartWavesWidth(X)
    channelStartIndex = 15:12:147;
    channels = ["DI" "DII" "DIII" "AVR" "AVL" "AVF" "V1" "V2" "V3" "V4" "V5" "V6"];
    waves = ["Q" "R" "S" "R'" "S'"];

    for i=1:length(channelStartIndex)
        
        figure(2+floor(i./7));
        
        if mod(i,6) == 0
            subplot(3,2,6);
        else
            subplot(3,2,mod(i,6));
        end

        j=channelStartIndex(i);
        
        data = X(:,j:j+4);

        boxchart(data);
        title(string(channels(1,i)));
        set(gca, 'XTickLabel', waves);
        ylabel('Average width (msec)');
    end

end

boxChartWavesWidth(X);

% CORRELATION TABLE

R = corr(X, 'rows', 'complete');

% Remove self-correlation
R_no_diag = R - diag(diag(R));
absR = abs(R_no_diag);

% Threshold
threshold = 0.7;
[row, col] = find(absR > threshold);

% Subset the correlation matrix and names
strongIdx = unique([row; col]);

smallR = R(strongIdx, strongIdx);
featuresNames= VarNames(strongIdx);

% Mask weak correlations with NaN
smallMask = abs(smallR) > 0.7;
strongOnly = nan(size(smallR));
strongOnly(smallMask) = smallR(smallMask);

figure(4);
heatmap(featuresNames, featuresNames, strongOnly, ...
    'Colormap', parula, ...
    'ColorLimits', [-1 1], ...
    'MissingDataLabel', 'No corr');
title('Strong Correlations |r| > 0.7');
