clear;
clc;

load("arrhythmia.mat");

function showWaves = showChannelsWaves(X)
    channelFirstIndex = [16 28 40 52 64 76 88 100 112 124 136 148];
    titles = ['DI' 'DII' 'DII' 'AVR' 'AVL' 'AVF' 'V1' 'V2' 'V3' 'V4' 'V5' 'V6'];

    for i=1:length(channelFirstIndex)
        
        figure(2+floor(i./7));
        if mod(i,6) == 0
            subplot(3,2,6);
        else
            subplot(3,2,mod(i,6));
        end

        j=channelFirstIndex(1,i);

        boxchart(X(:,j:j+4));
        title(string(titles(1,i)));
        xlabel('Waves');
        ylabel('Average width (msec)');
    end
end


% Age boxchart plot

figure(1);
boxchart(X(:, 1));
ylabel('Age (y)');

showChannelsWaves(X);