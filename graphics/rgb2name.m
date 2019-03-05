function name = rgb2name(rgb, return_long_name)
%RGB2NAME Returns the name of a fixed RGB color.
% Usage:
%   name = rgb2name(rgb)
%   name = rgb2name(rgb, return_long_name)
%
% Set return_long_name to false to return the short name.
% Returns an empty string if the color is not found.
%
% See also: fixed_colors, ColorSpec

if nargin < 2
    return_long_name = false;
end

% Get the fixed MATLAB colors
ColorSpec = fixed_colors();

% Look for specified color
if size(rgb) == [1, 3]
    idx = find(ismember(ColorSpec.rgb_triples, rgb, 'rows'));
else
    idx = [];
end

if isempty(idx)
    name = '';
    return
end

if return_long_name
    name = ColorSpec.long_names{idx};
else
    name = ColorSpec.short_names{idx};
end

end

