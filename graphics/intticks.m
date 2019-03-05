function intticks(ax, whichAxes)
%INTTICKS Makes axis ticks display as whole numbers.
% Usage:
%   intticks
%   intticks('x') % hides only x-ticks
%   intticks(ax, ...)
%
% See also: shortticks

if nargin == 1
    if ischar(ax)
        whichAxes = ax;
        clear ax
    end
end

% Defaults
if ~exist('whichAxes', 'var'); whichAxes = 'xyz'; end
if ~exist('ax', 'var'); ax = gca; end

if any(whichAxes == 'x')
    ax.XAxis.Exponent = 0;
end

if any(whichAxes == 'y')
    ax.YAxis.Exponent = 0;
end

if any(whichAxes == 'z')
    ax.ZAxis.Exponent = 0;
end

end

