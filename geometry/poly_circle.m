function circle = poly_circle(radius, center, num_points)
%POLY_CIRCLE Returns a set of points on the radius of a circle.
% Usage:
%   circle = poly_circle(radius)
%   circle = poly_circle(radius, center)
%   circle = poly_circle(radius, center, num_points)
% 
% See also: draw_circle

if nargin < 2
    center = [0, 0];
end
if nargin < 3
    num_points = 100;
end

center = validatepoints(center);

angles = linspace(0, 2 * pi, num_points);
[X, Y] = pol2cart(angles, radius);
circle = [X(:) + center(1) Y(:) + center(2)];

end

