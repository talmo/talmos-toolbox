function h = colorbar2(str, varargin)
%COLORBAR2 Colorbar with labeling!
% Usage:
%   colorbar2      % works like colorbar
%   colorbar2(str) % label with str if not empty
%   colorbar2(str, ...) % pass colorbar parameters
%   h = colorbar2(_) % returns handle to colorbar
% 
% See also: colorbar

h = colorbar(varargin{:});

if nargin > 0 && ~isempty(str)
    h.Label.String = str;
end

if nargout < 1; clear h; end
end
