function originax(ax, whichAxes)
%ORIGINAX Sets the axis location to the origin.
% Usage:
%   originax
%   originax y
%   originax(ax)
%   originax(ax, 'x')
% 
% See also: logaxis, noticks, noax, linkax

if nargin < 1; ax = []; end
if nargin < 2; whichAxes = []; end

if ischar(ax)
    [ax, whichAxes] = swap(ax, whichAxes);
end
if isempty(ax); ax = gca; end
if isempty(whichAxes); whichAxes = 'xyz'; end

if any(whichAxes == 'x'); ax.XAxisLocation = 'origin'; end
if any(whichAxes == 'y'); ax.YAxisLocation = 'origin'; end
if any(whichAxes == 'z') && isfield(ax,'ZAxisLocation'); ax.ZAxisLocation = 'origin'; end

end
