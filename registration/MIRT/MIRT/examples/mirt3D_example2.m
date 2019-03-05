% MIRT3D_EXAMPLE2: Non-rigid 3D registration example 2.
% Brain MRI (T1) image registration. The images are taken from BrainWeb
% www.bic.mni.mcgill.ca/brainweb/
clear all; close all; clc;
load mirt3D_brain1.mat;

% Main settings
main.similarity='ssd';  % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS, MI   
main.subdivide=3;       % use 3 hierarchical levels
main.okno=16;           % mesh window size
main.lambda = 0.01;     % transformation regularization weight, 0 for none
%main.alpha=0.01;       % similarity measure parameter (use with RC, MS or CD2)    


% Optimization settings
optim.maxsteps = 100;    % maximum number of iterations at each hierarchical level
optim.fundif = 1e-6;     % tolerance (stopping criterion)
optim.gamma = 1;         % initial optimization step size 
optim.anneal=0.8;        % annealing rate on the optimization step    
 

[res, newim]=mirt3D_register(refim, im, main, optim);

% res is a structure of resulting transformation parameters
% newim is a deformed image 
%
% you can also apply the resulting transformation directly as
% newim=mirt3D_transform(im, res);

figure,imshow(refim(:,:,50)); title('Reference (fixed) image slice');
figure,imshow(im(:,:,50));    title('Source (float) image slice');
figure,imshow(newim(:,:,50)); title('Registered (deformed) image slice');

