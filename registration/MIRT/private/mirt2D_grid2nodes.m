% MIRT2D_GRID2NODES  transforms the dense gradient to the
% gradient at each node (B-spline control point).
%
% Input 
% ddx, ddy - the gradient of similarity measure at each image pixel
% in x and y directions respectively
%
% F - is a precomputed matrix of B-spline basis function coefficients, see.
% mirt2D_F.m file
%
% okno - is a spacing width between the B-spline control points
% mg, ng - the size of B-spline control points in x,y directions
%
% Output
% Gr - a 3D array of the gradient of the similarity measure at B-spline
% control point positions. The first 2 dimenstion (size = mg x ng) is the organized control
% points. The 3rd dimesion (size 2) is the index of x or y  component.


% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/

function Gr=mirt2D_grid2nodes(ddx, ddy, F, okno, mg, ng)

% greate the 2D matrices wich includes
% the gradient of the similarity measure at
% each of the B-spline control points
grx=zeros(mg,ng);
gry=zeros(mg,ng);

% cycle over all 4x4 patches of B-spline control points
for i=1:mg-3,
    for j=1:ng-3,

        % define the indices of the voxels corresponding
        % to the given 4x4 patch    
        in1=(i-1)*okno+1:i*okno;
        in2=(j-1)*okno+1:j*okno;
        
        % extract the voxel-wise gradient (in x direction) of the similarity measure
        % that correspond to the given 4x4 patch of B-spline cotrol
        % points. 
        tmp=ddx(in1,in2);
        
        % multiply the voxel-wise gradient by the transpose matrix of
        % precomputed B-spline basis functions and accumulate into node-wise (B-spline)
        % gradient. Accumulation is because some B-spline control
        % points are shared between the patches
        grx(i:i+3,j:j+3,1)=grx(i:i+3,j:j+3,1)+reshape(F'*tmp(:),[4 4]);
  
        % do the same thing for y coordinates
        tmp=ddy(in1,in2);
        gry(i:i+3,j:j+3,1)=gry(i:i+3,j:j+3,1)+reshape(F'*tmp(:),[4 4]);
    
    end
end

% concatinate into a single 3D array
Gr=cat(3, grx, gry);