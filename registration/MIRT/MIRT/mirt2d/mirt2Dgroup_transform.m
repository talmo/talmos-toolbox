% a=mirt2Dgroup_transform(a, res)  applies the transformation
% stored in res structure (output of mirt2Dgroup_sequence,mirt2Dgroup_frame) to the image
% sequence a

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
%     This file is part of the Medical Image Registration Toolbox (MIRT).

function a=mirt2Dgroup_transform(a, res)

dimen=size(a);
% Precompute the B-spline basis functions
F=mirt2D_F(res.okno);

% for all 2D images
for volume=1:dimen(end)
    
    % compute the dense pixel coordinates (Xx,Xy) from the B-spline control points
    % in res.X.
    [Xx,Xy]=mirt2D_nodes2grid(res.X(:,:,:,volume), F, res.okno);
    % interpolate the current 3D volume
    newim=mirt2D_mexinterp(a(:,:,volume), Xx, Xy); newim(isnan(newim))=0;
    
    % cut the black border produced by the B-spline control points 
    % so that the interpolated images are of the same size as originals.
    [M,N]=size(newim);
    a(1:min(dimen(1),M),1:min(dimen(2),N),volume)=newim(1:min(dimen(1),M),1:min(dimen(2),N));
    
end

