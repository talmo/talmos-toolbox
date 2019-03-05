% MIRT2D_EXAMPLE2: Non-rigid 2D registration example 2 with Residual Complexity (RC)
% similarity measure, where one of the images is corrupted by nonstationary
% intensity distortion. Try using other similarity measures, e.g. SSD, CC
% or MI to see that they won't work with nonstationary instensity distortions

clear all; close all; clc;
load mirt2D_data2.mat;  


 % Main settings
main.similarity='rc';   % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS, MI  
main.alpha=0.05;        % similarity measure parameter (e.g., alpha of RC)
main.subdivide=3;       % use 3 hierarchical levels
main.okno=8;            % mesh window size, the smaller it is the more complex deformations are possible
main.lambda = 0.005;    % transformation regularization weight, 0 for none
main.single=1;          % show mesh transformation at every iteration

% Optimization settings
optim.maxsteps = 200;   % maximum number of iterations at each hierarchical level
optim.fundif = 1e-5;    % tolerance (stopping criterion)
optim.gamma = 1;       % initial optimization step size 
optim.anneal=0.8;       % annealing rate on the optimization step    
 

[res, newim]=mirt2D_register(refim,im, main, optim);

% res is a structure of resulting transformation parameters
% newim is a deformed image 
%
% you can also apply the resulting transformation directly as
% newim=mirt2D_transform(im, res);

figure,imshow(refim); title('Reference (fixed) image');
figure,imshow(im);    title('Source (float) image');
figure,imshow(newim); title('Registered (deformed) image');


