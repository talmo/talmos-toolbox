function h = titlef(str, varargin)
%TITLEF Sets the figure title with string formatting.
% Usage:
%   titlef(str, ...)
%   h = titlef(str, ...)

if nargin > 1
    str = sprintf(str, varargin{:});
end

str = strsplit(str, '\\n'); % multi-line support

h = title(str);

if nargout < 1
    clear h
end
end

