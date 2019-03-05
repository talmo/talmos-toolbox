function I = argsort(X, varargin)
%ARGSORT Convenience wrapper for sort, which returns indices of sorted items.
% Usage:
%   I = argsort(X)
%   I = argsort(X, dim, 'descend') % 'ascend' (default)
%
% See also: sort

[~, I] = sort(X, varargin{:});

end

