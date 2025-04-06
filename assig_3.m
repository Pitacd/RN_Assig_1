clc 
clear

load('arrhythmia.mat');

figure(1);
subplot(2,1,1);
histogram(X(:, 1));
ylabel('Number of patients');
xlabel('Age (y)');

figure(1);
subplot(2,1,2);
histogram(Y);
ylabel('Number of patients');
xlabel('Classes(Y)');

figure(2);
scatter(X(:,15),Y(:,1),"filled");
ylabel('Class(Y)');
xlabel('Heart rate (per min)');
