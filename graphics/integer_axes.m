function integer_axes(scale)
%INTEGER_AXES Displays the tickmarks in the current figure as integers.
% Usage:
%   integer_axes()
%   integer_axes(scale)
%
% ticklabels can be numeric vectors which are converted to strings
% internally with num2str.
%
% Reference: http://www.mathworks.com/help/matlab/ref/axes_props.html
%
% See also: ax2int

if nargin < 1
    scale = 1.0;
end

xticks = get(gca, 'xtick') * scale;
yticks = get(gca, 'ytick') * scale;

set(gca, 'xticklabel', xticks)
set(gca, 'yticklabel', yticks)

set(gca, 'Visible', 'on')

set(gca, 'YDir', 'reverse');

end

