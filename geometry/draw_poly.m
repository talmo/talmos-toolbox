function [patch_h, Vx, Vy] = draw_poly(Px, Py, varargin)
%DRAW_POLY Plots a polygon from a set of points.
% Usage:
%   draw_poly(P)
%   draw_poly(Px, Py)
%   draw_poly(..., PatchSpec)
%   draw_poly(..., 'Name', Value)
%   [patch_h, Vx, Vy] = draw_poly(...)
%   [patch_h, V] = draw_poly(...)
%
% Args:
%   P: matrix of points. The vertices of the polygon will be computed from
%       the convex hull of the points (see the 'ComputeHull' parameter).
%   Px, Py: component vectors of points
%   PatchSpec: string that controls the appearance of the polygon.
%       The format can be any of:
%           '[color][alpha]', '[alpha][color]', '[color]', '[alpha]'
%       [color]: Specifies the color of the face, edges and vertices of the
%                polygon. These are any of the ColorSpec() character codes:
%                  'y', 'm', 'c', 'r', 'g', 'b', 'w', 'k'
%                If [color] is omitted, the next plot color is used,
%                similar to plot() behavior. See: get_next_plot_color()
%       [alpha]: Specifies the transparency of the face of the polygon.
%                Valid values are numbers between 0 and 1.
%       Defaults to '0.5'.
%
% Parameters:
%   'ComputeHull': If true, the convex hull of the points will be computed
%       to specify the vertices of the polygon, which will be a convex and
%       closed polygonal chain.
%       This may also reduce the graphics overhead by reducing the number
%       of points and edges to draw.
%       To plot concave polygons, set this to false.
%       Defaults to true.
%   'PointsLineSpec': the LineSpec (see plot()) of the points. Leave empty
%       to disable plotting the points. Defaults to ''.
%   'VertexLineSpec': the LineSpec (see plot()) of the vertices. Leave
%       empty to disable plotting the vertices. Defaults to '.'.
%   'AdjustAxes': Adjusts the axes to use 'ij' and 'equal' profiles for the 
%       axis() function. Defaults to true.
%   'Parent': handle to the axes on which the polygon should be plotted.
%       Defaults to the current axes (gca).
%
% Returns:
%   patch_h: handle to the patch object
%   Vx, Vy: component vectors of the vertices of the polygon
%   V: matrix of the vertices of the polygon
%
% See also: draw_polys, plot_regions, get_next_plot_color, ColorSpec, axis

% Handle points specified as a matrix
if nargin < 2
    % Single input
    [Px, Py] = validatepoints(Px);
elseif ischar(Py)
    % Second argument is a parameter
    varargin = [{Py} varargin];
    [Px, Py] = validatepoints(Px);
end
patch_h = [];
if nunique(Px) < 3; return; end

% Process parameters and get vertices
try
    [Vx, Vy, params] = parse_inputs(Px, Py, varargin{:});
catch
    return;
end

% Save previous hold state
hold_state = get_hold_state(params.Parent);
if strcmp(hold_state, 'off')
    hold on
end

% Draw patch!
patch_h = patch('Parent', params.Parent, 'XData', Vx, 'YData', Vy, ...
    'FaceColor', params.PatchColor, 'FaceAlpha', params.PatchAlpha, ...
    'EdgeColor', params.PatchColor);

% Plot the original points if LineSpec is non-empty
if ~isempty(params.PointsLineSpec)
    plot(Px, Py, params.PointsLineSpec, params.PointsColor{:})
end

% Plot the vertices if the LineSpec is non-empty
if ~isempty(params.VertexLineSpec)
    plot(Vx, Vy, params.VertexLineSpec, params.PointsColor{:})
end

% Adjust axes
if params.AdjustAxes
    axis(params.Parent, 'ij', 'equal')
end

% Restore previous hold state
hold(hold_state);

% Output
if nargout< 1
    clear patch_h
end
if nargout == 2
    Vx = [Vx Vy];
end

end

function [Vx, Vy, params] = parse_inputs(Px, Py, varargin)
% Create inputParser instance
p = inputParser;

% Patch specifications
% We must validate with the regex since this parameter is optional
color_chars = get_color_names();
color_regex = ['[' color_chars ']?'];
alpha_regex = '[01]?(\.\d+)?';
p.addOptional('PatchSpec', '0.5', @(x) ischar(x) && ...
    instr(x, color_regex, 'r') || instr(x, alpha_regex, 'r'));

% Compute convex hull
p.addParameter('ComputeHull', true);

% Point and vertex specifications
p.addParameter('PointsLineSpec', '');
p.addParameter('VertexLineSpec', '');

% Adjust axes properties
p.addParameter('AdjustAxes', true);

% Parent axes
p.addParameter('Parent', gca, @(x) ~isempty(x) && ishghandle(x));

% Validate and parse input
p.parse(varargin{:});
params = p.Results;

% Parse patch color from PatchSpec string
match = regexpi(params.PatchSpec, color_regex, 'match', 'once');
params.PatchColor = lower(match);

% No color specified, use the next plot color
if isempty(params.PatchColor)
    params.PatchColor = get_next_plot_color(params.Parent);
end

% Parse patch alpha from PatchSpec string
match = regexpi(params.PatchSpec, alpha_regex, 'match', 'once');
params.PatchAlpha = str2double(match);

% If omitted, match will be '', so PatchAlpha will be NaN; use the default
if isnan(params.PatchAlpha); params.PatchAlpha = 0.5; end
params.PatchAlpha = min(params.PatchAlpha, 1);

% Use the same color as the patch to plot the points unless user explicitly
% specifies a color in the LineSpec
params.PointsColor = {}; params.VertexColor = {};
if ~instr(params.PointsLineSpec, color_regex, 'r')
    params.PointsColor = {'Color', params.PatchColor};
end
if ~instr(params.VertexLineSpec, color_regex, 'r')
    params.VertexColor = {'Color', params.PatchColor};
end

% Compute convex hull of the set of points to get polygon vertices
if params.ComputeHull
    K = convhull(double(Px), double(Py), 'simplify', true);
    Vx = Px(K);
    Vy = Py(K);
end
end