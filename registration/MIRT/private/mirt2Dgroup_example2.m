% MIRT2Dgroup_example2, Group-wise nonrigid image registration
% (frame by frame mode). 
% 
% advantages: fast to process, only 2 frames registration at a time
% sequentially, only 2 neigborhood frames should be consistent, which
% allows large intensity artifacts.
%
% This works OK if all frames have good initial view overlap, e.g.
% ultrasound video of the heart. If the overlaps are rather small 
% (camera moves out out of the plane) then use group-wise (all to the mean
%  groupwise registration, see mirt2Dgroup_example1.m).

% You can also run it from the gui, 
% run MIRT_GUI and then load mirt2Dgroup_data1.mat 
% set the group mode option to next-to-previous
% set the numer of iterations to a 100
% run mesh registration


clear all; close all; clc;
load mirt2Dgroup_data1.mat;

% Main parameters
main.group=1;           % Groupwise mode option: 0 - all frames are registered  to the first frame
                        %                        1 - every next frame is registered to the previous sequentially
                        %                        2 - every next frame is registred to the average of the previously registered frames 
                        %                            (accumulated memory)

main.okno=20;           % mesh window size
main.similarity='mi';   % similarity measure 
main.MIbins=32;

main.subdivide = 3;     % number of hierarchical levels
main.lambda = 0.01;     % regularization weight, 0 for none
main.alpha=0.1;         % similarity measure parameter
main.single=0;          % don't show the mesh at each iteration


% Optimization parameters
optim.maxsteps = 100;    % maximum number of iterations
optim.fundif = 1e-5;    % tolerance
optim.gamma = 1;      % initial optimization step size
optim.anneal=0.8;       % annealing rate


a(a==0)=nan;    % set zeros to nans, the black color here corresponds to the border
                % around the actual images. We exclude this border by
                % setting it to NaNs.


res=mirt2Dgroup_frame(a, main, optim); % find the transformation (frame by frame)
b=mirt2Dgroup_transform(a, res);       % apply the transformation

% see the result
for i=1:size(b,3), imshow(b(:,:,i)); drawnow; pause(0.1); end;

%%% also you can save the result to avi as
%
% F=mirt2D_mat2avi(b);
% movie2avi(F, 'mymovie.avi','colormap',colormap(gray));

