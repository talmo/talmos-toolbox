function [pts_x,pts_y] = getEllipsePoints(ell, alpha, origin_line)
%GETELLIPSEPOINTS Returns points along an ellipse at the specified angle.
% Usage:
%   pts = getEllipsePoints(ell, alpha)
%   [pts_x,pts_y] = getEllipsePoints(ell, alpha)
%
% Args:
%   ell: [center_x center_y major_axis minor_axis angle_degrees]
%   alpha: angles in degrees (0 - 360) (default: 0:2:360)
%   origin_line: includes line from theta = 0 to centroid (default: false)
%
% Returns:
%   pts: Nx2 array of points
% 
% See also: drawEllipse

if nargin < 2 || isempty(alpha); alpha = 0:2:360; end
if nargin < 3 || isempty(origin_line); origin_line = false; end

x0 = ell(1);
y0 = ell(2);
a = ell(3);
b = ell(4);
theta = ell(5);

cot = cosd(theta);
sit = sind(theta);

coa = cosd(alpha);
sia = sind(alpha);

pts_x = x0 + a * coa * cot - b * sia * sit;
pts_y = y0 + a * coa * sit + b * sia * cot;

pts_x = pts_x(:);
pts_y = pts_y(:);

if origin_line
    ori_x = [x0; x0 + a * cosd(0) * cosd(theta) - b * sind(0) * sind(theta)];
    ori_y = [y0; y0 + a * cosd(0) * sind(theta) + b * sind(0) * cosd(theta)];
    
    pts_x = [pts_x; NaN; ori_x];
    pts_y = [pts_y; NaN; ori_y];
end

if nargout < 2
    pts_x = [pts_x(:) pts_y(:)];
end
end
