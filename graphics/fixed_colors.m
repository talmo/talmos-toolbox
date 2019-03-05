function colorspec_table = fixed_colors
%FIXED_COLORS Returns a table with all of the fixed MATLAB colors.
% Usage:
%   colorspec_table = fixed_colors()
%
% The table has the fields: rgb_triples, short_names, long_names
%
% Reference: http://www.mathworks.com/help/matlab/ref/colorspec.html
%
% See also: ColorSpec, get_color_names

short_names = {'y', 'm', 'c', 'r', 'g', 'b', 'w', 'k'}';
long_names = {'yellow', 'magenta', 'cyan', 'red', 'green', 'blue', 'white', 'black'}';
rgb_triples = cell2mat({[1 1 0], [1 0 1], [0 1 1], [1 0 0], [0 1 0], [0 0 1], [1 1 1], [0 0 0]}');

colorspec_table = table(rgb_triples, short_names, long_names);

end

