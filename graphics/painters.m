function painters(fig)
%PAINTERS Sets the figure renderer to painters.
% Usage:
%   painters
%   painters(fig)
% 
% Args:
%   fig: figure handle (default: gcf)
% 
% See also: figure

if nargin < 1; fig = gcf; end

set(fig, 'Renderer','painters')

end
