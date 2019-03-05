function [tform, T] = scale2d(sX, sY)
%SCALE2D Returns a 2D scaling transform.
% Usage:
%   tform = scale2d(sXY)
%   tform = scale2d(sX, SY)
%   [tform, T] = scale2d(_)
%
% Returns:
%   tform: affine2d object
%   T: 3x3 transformation matrix
%
% See also: rot2d, trans2d, affine2d

if nargin < 2
    if isscalar(sX); sX = [sX sX]; end
    sY = sX(2);
    sX = sX(1);
end

T = [sX  0  0
      0 sY  0
      0  0  1];
 
tform = affine2d(T);

end

