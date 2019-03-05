function [C2,idx] = celljoin(C, delim, dim)
%CELLJOIN Concatenates a cell array with specified delimiter.
% Usage:
%   C2 = celljoin(C)
%   C2 = celljoin(C, 'nan')
%   C2 = celljoin(C, delim)
%   C2 = celljoin(C, delim, dim)
%   [C2, idx] = celljoin(_)
%
% Args:
%   C: cell array
%   delim: delimeter to use (default: 'nan')
%   dim: dimension to concatenate across (default: 1)
%
% Returns:
%   C2: merged array
%   idx: index of connected component for each element in C2
%
% Note: If 'nan' is specified as the delimiter, an appropriately sized NaN
% array will be used as the delimiter.

if nargin < 2; delim = 'nan'; end
if nargin < 3; dim = 1; end

if ischar(delim) && strcmp(delim, 'nan')
    sz = size(C{1});
    sz(dim) = 1;
    delim = NaN(sz);
end

[C2,idx] = cellcat([horz(C); repmat({delim},1,numel(C))]);

% NaN out even numbers (delimiters)
idx(mod(idx,2) == 0) = NaN;

% Readjust indexing to match C
idx(~isnan(idx)) = (idx(~isnan(idx)) - 1) / 2 + 1;

end

