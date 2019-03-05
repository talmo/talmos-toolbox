% Initialize the eigenvalues of the discrete Laplacian in 3D
% Input
% siz - size of the 2D object (e.g. 2D image or 2D array of B-spline control points)
% to which we will apply the regularization
%
% Output
% K - a 2D matrix of size 'siz' with the eigenvalues of the discrete
% Laplacaian 

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
% This file is part of the Medical Image Registration Toolbox (MIRT).

function K=mirt2D_initK(siz)

% extract the projected size
M=siz(1);
N=siz(2);


% create the 1D arrays of eigenvalues in x,y directions
v1=cos((pi/M)*(0:M-1)');
v2=cos((pi/N)*(0:N-1));


% compute the 2D array with eigenvalues of the 2D Laplacian
K=repmat(v1,[1 N])+repmat(v2,[M 1]);
K=2*(2-K);

% square is because we use Laplacian regularization
% If we use gradient-based regularization, the squaring is not required
K=K.^2;


