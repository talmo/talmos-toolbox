function draw_polys(polygons, varargin)
%DRAW_POLYS Draw a cell array of polygons.
% Usage:
%   draw_polys(polygons)
%   draw_polys(polygons, ...)
% 
% This function accepts additional parameters for draw_poly.
% 
% See also: draw_poly

for i = 1:numel(polygons)
    draw_poly(polygons{i}, varargin{:});
end

end

