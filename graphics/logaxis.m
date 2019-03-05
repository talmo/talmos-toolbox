function logaxis(ax, whichAxes)
%LOGAXIS Sets the axis to log scale.
% Usage:
%   logaxis
%   logaxis y
%   logaxis(ax)
%   logaxis(ax, 'x')
% 
% See also: noticks, noax, linkax

if nargin < 1; ax = []; end
if nargin < 2; whichAxes = []; end

if ischar(ax)
    [ax, whichAxes] = swap(ax, whichAxes);
end
if isempty(ax); ax = gca; end
if isempty(whichAxes); whichAxes = 'xyz'; end

if any(whichAxes == 'x'); ax.XScale = 'log'; end
if any(whichAxes == 'y'); ax.YScale = 'log'; end
if any(whichAxes == 'z'); ax.ZScale = 'log'; end

end
