% MIRT2D_NODES2GRID  computes the dense transformation (positions of all image pixels)
% from the current positions of B-spline control points.
%
% Input
% X - 4D array of B-spline control point positions. The first 2 dimensions
% include the coordinates of B-spline control points in a particular
% image. The 3rd dimension is of size 2, it indicates wheather it is the
% X or Y coordinate. The 4th dimension is time (image number).
%
% F - is a precomputed matrix of B-spline basis function coefficients, see.
% mirt2D_F.m file
%
% okno - is a spacing width between the B-spline control points
%
% Output
% Xx,Xy - 2D matrices of positions of all image voxels computed from the
% corresponding positions of B-spline control points

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/

function [Xx,Xy]=mirt2D_nodes2grid(X, F, okno)

[mg,ng,tmp]=size(X);

% Computer the dense transformation in Xx and Xy
% Go over all 4x4 patches of B-spline control points
for i=1:mg-3,
    for j=1:ng-3,
        
        % define the indices of the pixels corresponding
        % to the given 4x4 patch
        in1=(i-1)*okno+1:i*okno;
        in2=(j-1)*okno+1:j*okno;
   
        % take the X coordinates of the current 4x4 patch of B-spline
        % control points, rearrange in vector and multiply by the matrix
        % of B-spline basis functions (F) to get the dense coordinates of 
        % the voxels within the given patch
        tmp=X(i:i+3,j:j+3,1);
        Xx(in1,in2)=reshape(F*tmp(:),[okno okno]);

        % repeat for Y coordinates of the patch
        tmp=X(i:i+3,j:j+3,2);
        Xy(in1,in2)=reshape(F*tmp(:),[okno okno]);
    end
end
