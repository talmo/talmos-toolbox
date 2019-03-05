% im=mirt3D_transform(refim, res)  applies the transformation
% stored in res structure (output of mirt3D_register) to the 3D image refim

% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
% This file is part of the Medical Image Registration Toolbox (MIRT).

function im=mirt3D_transform(refim, res)

dimen=size(refim);

% Precompute the matrix B-spline basis functions
F=mirt3D_F(res.okno);

% obtaine the position of all image voxels (Xx,Xy,Xz) from the positions
% of B-spline control points (res.X)
[Xx,Xy,Xz]=mirt3D_nodes2grid(res.X, F, res.okno);

% interpolate the image refim at Xx, Xy, Xz
newim=mirt3D_mexinterp(refim, Xx, Xy,Xz); newim(isnan(newim))=0;

% cut the interpolated image size to the original size
% the image produced by B-splines has an additional black border,
% these lines remove that border.
im=zeros(dimen);
[M,N,K]=size(newim);
im(1:min(dimen(1),M),1:min(dimen(2),N),1:min(dimen(3),K))=newim(1:min(dimen(1),M),1:min(dimen(2),N),1:min(dimen(3),K));

