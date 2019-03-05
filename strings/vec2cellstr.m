function C = vec2cellstr(V, formatSpec)
%VEC2CELLSTR Converts a vector into a cell array of strings.
% Usage:
%   C = vec2cellstr(V)
%   C = vec2cellstr(V, formatSpec)
%
% See also: vec2str, num2str, int2str

if nargin < 2
    C = strsplit(num2str(V(:)'));
else
    C = af(@(x) num2str(x,formatSpec), V);
end

end

