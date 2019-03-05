% MIRT2Dgroup_example1, Group-wise nonrigid image registration
% (iteratively all frames to the mean). Stabilization of the microscopic video.
% This groupwise mode takes longer time to compute then frame by frame (see mirt2Dgroup_example2),
% but it provides much better results, especially when some frames have only a small overlap.
% This group-wise mode also allows much better mosaicing of the frames,
% however it can take up to several hours to finish depending on you video
% size and lenght.
%
% You can also run it from the gui, run MIRT_GUI and then load mirt2Dgroup_data1.mat !!!
% run mesh registration


clear all; close all; clc;
load mirt2Dgroup_data1.mat;

% Main parameters
main.okno=20;           % mesh window size
main.similarity='rc';   % similarity measure 
main.subdivide = 3;     % number of hierarchical levels
main.lambda = 0.01;     % regularization weight, 0 for none
main.alpha=0.1;         % similarity measure parameter
main.single=0;          % don't show the mesh at each iteration


% Optimization parameters
optim.maxsteps = 40;    % maximum number of iterations (for a given frame being registered to the mean image)
optim.fundif = 1e-5;    % tolerance (for a given frame)
optim.gamma = 10;      % initial optimization step size
optim.anneal=0.8;       % annealing rate

optim.imfundif=1e-6;    % Tolerance of the mean image (change of the mean image)
optim.maxcycle=30;      % maximum number of cycles (at each cycle all frames are registered to the mean image)


a(a==0)=nan;    % set zeros to nans, the black color here corresponds to the border
                % around the actual images. We exclude this border by
                % setting it to NaNs.
                
res=mirt2Dgroup_sequence(a, main, optim);  % find the transformation (all to the mean)
b=mirt2Dgroup_transform(a, res);           % apply the transformation


% see the result
for i=1:size(b,3), imshow(b(:,:,i)); drawnow; pause(0.1); end;

%%% also you can save the result to avi as
%
% F=mirt2D_mat2avi(b);
% movie2avi(F, 'mymovie.avi','colormap',colormap(gray));