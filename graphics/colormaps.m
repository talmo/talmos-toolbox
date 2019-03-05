function [maps, map_values] = colormaps(M)
%COLORMAPS Returns a list of standard MATLAB colormaps.
% Usage:
%   maps = colormaps
%   [maps, map_values] = colormaps
%   [maps, map_values] = colormaps(M)
%
% Args:
%   M: number of colors in the colormap (default: 64)
%
% Returns:
%   maps: cell array of strings with the standard colormap names
%   map_values: cell array of Mx3 arrays containing colormap values
%
% See also: colormap, iscolormap

maps = {
	'autumn'
	'bone'
	'colorcube'
	'cool'
	'copper'
	'flag'
	'gray'
	'hot'
	'hsv'
	'jet'
	'lines'
	'pink'
	'prism'
	'spring'
	'summer'
	'white'
	'winter'
	'parula'
};

if nargout < 2
    return;
end

% Number of colors in the colormap
if nargin < 1
    M = size(get(groot,'DefaultFigureColormap'),1);
end

% Get colormap values
map_values = cf(@(x) feval(x,M), maps);

end

