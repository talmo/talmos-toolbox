function [RGB, colorChar] = nextColor(ax, doIncrement)
%NEXTCOLOR Returns the next color to be used in the current axis.
% Usage:
%   [RGB, colorChar] = nextColor
%   _ = nextColor(ax)
%   _ = nextColor(ax, doIncrement)
% 
% Args:
%   ax: axes object (default: gca)
%   doIncrement: increment the plot cycle (default: false)
%
% Returns:
%   RGB: 3-tuple of RGB values between 0 and 1
%   colorChar: character corresponding to the color ('' if not a preset)
% 
% See also: Axes

if nargin < 1 || isempty(ax); ax = gca; end
if nargin < 2; doIncrement = false; end
if islogical(ax); [ax,doIncrement] = swap(ax,doIncrement); end
if islogical(ax); ax = gca; end

RGB = ax.ColorOrder(ax.ColorOrderIndex,:);
colorChar = rgb2name(RGB);

if doIncrement
    N = size(ax.ColorOrder,1);
    idx = ax.ColorOrderIndex + 1;
    ax.ColorOrderIndex = mod(idx-1,N)+1;
end

end
