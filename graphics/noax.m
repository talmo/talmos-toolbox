function noax(ax, whichAxes)
%NOAX Hides an axis and its bounding lines.
% Usage:
%   noax
%   noax x % hide only x axis
%   noax(ax, 'x') % specify axes object
% 
% See also: noticks

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
    ax.XAxis.Visible = 'off';
end

if any(whichAxes == 'y')
    ax.YAxis.Visible = 'off';
end

if any(whichAxes == 'z')
    ax.ZAxis.Visible = 'off';
end

end
