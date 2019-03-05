function tform = imxcorralign(fixed, moving, varargin)
%IMXCORRALIGN Aligns two images via normalized cross correlation.
% Usage:
%   tform = imxcorralign(fixed, moving)
%   tform = imxcorralign(fixed, R_fixed, moving, R_moving)
%
% Args:
%   fixed: numeric 2-D image target
%   moving: numeric 2-D image to align to target
%   R_fixed: imref2d spatial referencing object for fixed image
%   R_moving: imref2d spatial referencing object for moving image
%
% Returns:
%   tform: an imref2d translation matrix to align moving to fixed

s = 1;
if nargin > 2 && ~iseven(nargin)
    s = varargin{end};
end
preT = affine2d([s 0 0;
                 0 s 0;
                 0 0 1]);
if nargin > 3
    Rf = moving;
    moving = varargin{1};
    Rm = varargin{2};
    
    Rf2 = tform_spatial_ref(Rf, preT);
    Rm2 = tform_spatial_ref(Rm, preT);
    Rout = merge_spatial_refs({Rf2, Rm2});
    
    fixed = imwarp(fixed, Rf, preT, 'OutputView', Rout);
    moving = imwarp(moving, Rm, preT, 'OutputView', Rout);
end

% Check for which is bigger
flipImages = size(fixed, 1) < size(moving, 1) || size(fixed, 2) < size(moving, 2);
if flipImages
    tmpFixed = fixed;
    fixed = moving;
    moving = tmpFixed;
    clear tmpFixed
end

% Compute normalized cross correlation
c = normxcorr2(moving, fixed);

% Find peak of correlation
[ypeak, xpeak] = find(c==max(c(:)));
dy = ypeak-size(moving, 1);
dx = xpeak-size(moving, 2);

% Adjust for flip
if flipImages
    dx = -dx;
    dy = -dy;
end

% Adjust for pre-scaling
dx = dx / s;
dy = dy / s;

% Create transformation
T = [1  0  0;
     0  1  0;
     dx dy 1];
tform = affine2d(T);

end

