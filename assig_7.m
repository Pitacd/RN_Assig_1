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

% --------//-----------

% Create New Features

% Feature 1: IMC
S = struct();
for i = 1:length(VarNames)
    nomeValido = matlab.lang.makeValidName(VarNames(i));
    S.(char(nomeValido)) = i;
    clear nomeValido;
end

nova_feature = X(:, S.Weight_Kg) ./ ((X(:,S.Height_Cm) / 100).^2);

clear S;

X = [nova_feature X];
VarNames = ['IMC' VarNames];


% Feature 2: Heart Rate Level
S = struct();
for i = 1:length(VarNames)
    nomeValido = matlab.lang.makeValidName(VarNames(i));
    S.(char(nomeValido)) = i;
    clear nomeValido;
end

nova_feature = X(:,S.HeartRatePerMinute) ./ (220 - X(:,S.Age_Years));

clear S;
X = [nova_feature X];
VarNames = ['maxHeartR/HeartR' VarNames];


% Feature 3-14: Heart Rate Level
S = struct();
for i = 1:length(VarNames)
    nomeValido = matlab.lang.makeValidName(VarNames(i));
    S.(char(nomeValido)) = i;
    clear nomeValido;
end

% Create QRS width for each channnel
chanDI_QRSdur = X(:,S.DIQWaveWidth) + X(:,S.DIRWaveWidth) + X(:,S.DISWaveWidth);
chanDII_QRSdur = X(:,S.DIIQWaveWidth) + X(:,S.DIIRWaveWidth) + X(:,S.DIISWaveWidth);
chanDIII_QRSdur = X(:,S.DIIIQWaveWidth) + X(:,S.DIIIRWaveWidth) + X(:,S.DIIISWaveWidth);
chanAVR_QRSdur = X(:,S.AVRQWaveWidth) + X(:,S.AVRRWaveWidth) + X(:,S.AVRSWaveWidth);
chanAVL_QRSdur = X(:,S.AVLQWaveWidth) + X(:,S.AVLRWaveWidth) + X(:,S.AVLSWaveWidth);
chanAVF_QRSdur = X(:,S.AVFQWaveWidth) + X(:,S.AVFRWaveWidth) + X(:,S.AVFSWaveWidth);
chanV1_QRSdur = X(:,S.V1QWaveWidth) + X(:,S.V1RWaveWidth) + X(:,S.V1SWaveWidth);
chanV2_QRSdur = X(:,S.V2QWaveWidth) + X(:,S.V2RWaveWidth) + X(:,S.V2SWaveWidth);
chanV3_QRSdur = X(:,S.V3QWaveWidth) + X(:,S.V3RWaveWidth) + X(:,S.V3SWaveWidth);
chanV4_QRSdur = X(:,S.V4QWaveWidth) + X(:,S.V4RWaveWidth) + X(:,S.V4SWaveWidth);
chanV5_QRSdur = X(:,S.V5QWaveWidth) + X(:,S.V5RWaveWidth) + X(:,S.V5SWaveWidth);
chanV6_QRSdur = X(:,S.V6QWaveWidth) + X(:,S.V6RWaveWidth) + X(:,S.V6SWaveWidth);

X = [chanDI_QRSdur chanDII_QRSdur chanDIII_QRSdur chanAVR_QRSdur chanAVL_QRSdur chanAVF_QRSdur chanV1_QRSdur chanV2_QRSdur chanV3_QRSdur chanV4_QRSdur chanV5_QRSdur chanV6_QRSdur X];
VarNames = ['chanDI_QRSdur' 'chanDII_QRSdur' 'chanDIII_QRSdur' 'chanAVR_QRSdur' 'chanAVL_QRSdur' 'chanAVF_QRSdur' 'chanV1_QRSdur' 'chanV2_QRSdur' 'chanV3_QRSdur' 'chanV4_QRSdur' 'chanV5_QRSdur' 'chanV6_QRSdur' VarNames];

clear chanDI_QRSdur chanDII_QRSdur chanDIII_QRSdur chanAVR_QRSdur chanAVL_QRSdur chanAVF_QRSdur chanV1_QRSdur chanV2_QRSdur chanV3_QRSdur chanV4_QRSdur chanV5_QRSdur chanV6_QRSdur;


% Display histograms

figure(1);
subplot(2,2,1);
histogram(X(:, 15));
ylabel('Frequency');
xlabel('Age (y)');

figure(1);
subplot(2,2,2);
histogram(X(:, 28));
ylabel('Frequency');
xlabel('Heart rate (bpm)');

figure(1);
subplot(2,2,3:4);
histogram(X(:, 13));
ylabel('Frequency');
xlabel('Heart Rate Level');

figure(2);
subplot(2,2,1);
histogram(X(:, 17));
ylabel('Frequency');
xlabel('Height (cm)');

figure(2);
subplot(2,2,2);
histogram(X(:, 18));
ylabel('Frequency');
xlabel('Weigth (kg)');

figure(2);
subplot(2,2,3:4);
histogram(X(:, 14));
ylabel('Frequency');
xlabel('IMC');

% Display correlation heatmap

figure(3)
R = corr(X(:,14), X(:, 17:18));
subplot(2,1,1);
heatmap({"Height (cm)", "Weight (kg)"},{"IMC"},R);

figure(3)
R = corr(X(:, 13), X(:, [15 28]));
subplot(2,1,2);
heatmap({"Age (y)", "Heart rate (bpm)"},{"Heart Rate Level"},R);

% QRS from DI to AVF

figure(4);
R = corr(X(:, 1), X(:, 29:31));
subplot(3,2,1);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('DI waves width');

figure(4);
R = corr(X(:, 2), X(:, 41:43));
subplot(3,2,2);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('DII waves width');

figure(4);
R = corr(X(:, 3), X(:, 53:55));
subplot(3,2,3);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('DIII waves width');

figure(4);
R = corr(X(:, 4), X(:, 65:67));
subplot(3,2,4);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('AVR waves width');

figure(4);
R = corr(X(:, 5), X(:, 77:79));
subplot(3,2,5);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('AVL waves width');

figure(4);
R = corr(X(:, 6), X(:, 89:91));
subplot(3,2,6);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('AVF waves width');

% QRS from V1 to V6

figure(5);
R = corr(X(:, 7), X(:, 101:103));
subplot(3,2,1);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('V1 waves width');

figure(5);
R = corr(X(:, 8), X(:, 113:115));
subplot(3,2,2);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('V2 waves width');

figure(5);
R = corr(X(:, 9), X(:, 125:127));
subplot(3,2,3);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('V3 waves width');

figure(5);
R = corr(X(:, 10), X(:, 137:139));
subplot(3,2,4);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('V4 waves width');

figure(5);
R = corr(X(:, 11), X(:, 149:151));
subplot(3,2,5);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('V5 waves width');

figure(5);
R = corr(X(:, 12), X(:, 161:163));
subplot(3,2,6);
heatmap({"Q", "R", "S"},{"QRS"},R);
title('V6 waves width');
