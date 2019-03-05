function h = gcf2
%GCF2 Returns the handle to the current figure WITHOUT creating a new one.
% Usage:
%   h = gcf2
%
% Returns:
%   h: handle to the current figure. Returns an empty array if there is no
%   figure open.
%
% See also: gcf, gca2

% Query the root graphics object without opening a new figure
h = get(0, 'CurrentFigure'); 

end

