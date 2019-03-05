function draw_circle(circle, PatchSpec)
%DRAW_CIRCLE Draws a circle specified as a polygon.
% Usage:
%   draw_circle(circle)
%   draw_circle(circle, PatchSpec)
% 
% See also: poly_circle, draw_poly

if nargin < 2
    PatchSpec = '0.5';
end

draw_poly(circle, PatchSpec, 'VertexLineSpec', '');

end

