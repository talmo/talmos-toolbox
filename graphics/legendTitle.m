function titleHandle = legendTitle(legendHandle, titleStr)
%LEGENDTITLE Adds a title to a legend box in a plot.
% Usage:
%   legendTitle(titleStr)
%   legendTitle(legendHandle, titleStr)
%   titleHandle = legendTitle(...)

if nargin < 2
    titleStr = legendHandle;
    legendHandle = legend(); % returns handle to the current legend
end

% Add text object right above the legend's container
titleHandle = text(...
    'Parent', legendHandle.DecorationContainer, ...
    'String', titleStr, ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'bottom', ...
    'Position', [0.5, 1.05, 0], ...
    'Units', 'normalized');

if nargout < 1
    clear titleHandle
end

end

