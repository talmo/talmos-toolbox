function h = gca2(fig_h)
%GCA2 Returns the handle to the current axes WITHOUT creating a new figure.
% Usage:
%   h = gca2
%   h = gca2(fig_h)
%
% Args:
%   fig_h: handle of the figure to query. Defaults to the current figure.
%
% Returns:
%   h: handle to the current axes. Returns an empty array if there is no
%   axes or figure.
%
% See also: gca, gcf2

% Get current figure
if nargin < 1
    fig_h = gcf2();
end

h = [];

% Query figure, if it exists, without opening a new one
if isfig(fig_h)
   h = get(fig_h, 'CurrentAxes'); 
end
end

