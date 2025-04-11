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

clear S;

X = [chanDI_QRSdur chanDII_QRSdur chanDIII_QRSdur chanAVR_QRSdur chanAVL_QRSdur chanAVF_QRSdur chanV1_QRSdur chanV2_QRSdur chanV3_QRSdur chanV4_QRSdur chanV5_QRSdur chanV6_QRSdur X];
VarNames = ['chanDI_QRSdur' 'chanDII_QRSdur' 'chanDIII_QRSdur' 'chanAVR_QRSdur' 'chanAVL_QRSdur' 'chanAVF_QRSdur' 'chanV1_QRSdur' 'chanV2_QRSdur' 'chanV3_QRSdur' 'chanV4_QRSdur' 'chanV5_QRSdur' 'chanV6_QRSdur' VarNames];

clear chanDI_QRSdur chanDII_QRSdur chanDIII_QRSdur chanAVR_QRSdur chanAVL_QRSdur chanAVF_QRSdur chanV1_QRSdur chanV2_QRSdur chanV3_QRSdur chanV4_QRSdur chanV5_QRSdur chanV6_QRSdur;


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
