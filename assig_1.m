clc; 
clear;

load("arrhythmia.mat");

% Show output : The workspace variables 
whos

% Show output : numb_rows x numb_colls of the tables X and Y
size(X)
size(Y)

% Show output : First 10 rows of the tables X and Y
X(1:10, :)
Y(1:10, 1)
