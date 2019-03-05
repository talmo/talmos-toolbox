function [tform, T] = rot2d(theta)
%ROT2D Generate a 2d rotation transformation.
% Usage:
%   tform = rot2d(theta)
%
% Args:
%   theta: rotation angle (in degrees)
%
% Returns:
%   tform: affine2d object
%   T: 3x3 transformation matrix
%
% See also: trans2d, affine2d
 
theta = deg2rad(theta);

T = [ cos(theta)  sin(theta) 0
     -sin(theta)  cos(theta) 0
              0           0  1];

tform = affine2d(T);
          
end

