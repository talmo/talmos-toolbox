function [tform, T] = trans2d(dX, dY)
%TRANS2D Returns a 2D translation transform.
% Usage:
%   tform = trans2d(dXY)
%   tform = trans2d(dX, dY)
%   [tform, T] = trans2d(_)
%
% Returns:
%   tform: affine2d object
%   T: 3x3 transformation matrix
%
% See also: rot2d, affine2d

if nargin < 2
    dY = dX(2);
    dX = dX(1);
end

T = [ 1  0  0
      0  1  0
     dX dY  1];
 
tform = affine2d(T);

end

