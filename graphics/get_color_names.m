function names = get_color_names()
%GET_COLOR_NAMES Returns the short color names of MATLAB's fixed colors in a string.
% Usage:
%   names = get_color_names()
%
% See also: fixed_colors, ColorSpec

color_table = fixed_colors();
names = strjoin(color_table.short_names', '');

end

