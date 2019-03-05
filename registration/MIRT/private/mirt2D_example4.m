% MIRT2D_EXAMPLE4: Non-rigid 2D registration example 4 with Mutual Information (MI)
% similarity measure. Multimodal image registration.
clear all; close all; clc;
load mirt2D_data4.mat;  


 % Main settings
main.similarity='MI';   % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS, MI
main.MIbins=64;         % number of bins for the Mutual Information similarity measure
main.subdivide=3;       % use 3 hierarchical levels
main.okno=10;            % mesh window size, the smaller it is the more complex deformations are possible
main.lambda = 0.01;    % transformation regularization weight, 0 for none
main.single=1;          % show mesh transformation at every iteration

% Optimization settings
optim.maxsteps = 200;   % maximum number of iterations at each hierarchical level
optim.fundif = 1e-5;    % tolerance (stopping criterion)
optim.gamma = 1;       % initial optimization step size 
optim.anneal=0.8;       % annealing rate on the optimization step    
 

[res, newim]=mirt2D_register(refim,im, main, optim);

% res is a structure of resulting transformation parameters
% newim is the deformed image 
%
% you can also apply the resulting transformation directly as
% newim=mirt2D_transform(im, res);

figure,imshow(refim); title('Reference (fixed) image');
figure,imshow(im);    title('Source (float) image');
figure,imshow(newim); title('Registered (deformed) image');


