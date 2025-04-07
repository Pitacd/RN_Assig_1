clc 
clear

load('arrhythmia.mat');

% Function to display two figures with boxcharts of each channel waves
% width
function showChannelsWaves(X)
    channelStartIndex = 16:12:148;
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

% Function to display two figures with boxcharts of each channel waves
% amplitude
function showAmplitudeWaves(X)
    channelStartIndex = 160:10:270;
    channels = ["DI" "DII" "DIII" "AVR" "AVL" "AVF" "V1" "V2" "V3" "V4" "V5" "V6"];
    waves = ["JJ", "Q", "R", "S", "R'", "S'", "P", "T", "QRSA", "QRSTA"];

    for i=1:length(channelStartIndex)
        
        figure(4+floor(i./7));
        
        if mod(i,6) == 0
            subplot(3,2,6);
        else
            subplot(3,2,mod(i,6));
        end

        j=channelStartIndex(i);
        
        data = X(:,j:j+9);

        boxchart(data);
        title(string(channels(1,i)));
        set(gca, 'XTickLabel', waves);
        ylabel('Amplitude (*0.1 milivolt)');
    end
end

figure(1);
subplot(3,1,1);
histogram(X(:, 1));
title('Age');
ylabel('Frequency');
xlabel('Age (y)');

figure(1);
subplot(3,1,2);
histogram(X(:, 2));
title('Sex');
ylabel('Frequency');
xlabel('Sex (0-male, 1-female)');

figure(1);
subplot(3,1,3);
histogram(X(:, 15)); 
title('Heart Rate');
xlabel('Beats (per min)');
ylabel('Frequency');

% Boxchart of each channel wave width
showChannelsWaves(X);

% Boxchart of each channel wave amplitude
showAmplitudeWaves(X);
