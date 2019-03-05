function ax2int(scale)
%AX2INT Displays the tickmarks in the current figure as integers. This is an alias for integer_axes.
% Usage:
%   ax2int()
%   ax2int(scale)
%
% See also: integer_axes

if nargin < 1
    scale = 1.0;
end

integer_axes(scale)

end

