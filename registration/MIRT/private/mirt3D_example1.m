% MIRT3D_EXAMPLE1: Non-rigid 3D registration example 1.
% Ultrasound image registration

clear all; close all; clc;
load mirt3D_echo1.mat;

% Main settings
main.similarity='MS';   % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS  
main.subdivide=3;       % use 3 hierarchical levels
main.okno=10;           % mesh window size
main.lambda = 0.01;     % transformation regularization weight, 0 for none

main.alpha=1;           
main.ro=0.6;

% Optimization settings
optim.maxsteps = 100;    % maximum number of iterations at each hierarchical level
optim.fundif = 1e-6;     % tolerance (stopping criterion)
optim.gamma = 1;         % initial optimization step size 
optim.anneal=0.8;        % annealing rate on the optimization step    
 

im(im==0)=nan;           % put nans to ignore the area outside of the ultrasound beam cone
refim(refim==0)=nan;


[res, newim]=mirt3D_register(refim, im, main, optim);

% res is a structure of resulting transformation parameters
% newim is a deformed image 
%
% you can also apply the resulting transformation directly as
% newim=mirt3D_transform(im, res);

figure,imshow(refim(:,:,50)); title('Reference (fixed) image slice');
figure,imshow(im(:,:,50));    title('Source (float) image slice');
figure,imshow(newim(:,:,50)); title('Registered (deformed) image slice');

