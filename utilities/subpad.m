function [Y,Xind,Yind] = subpad(X, subs, dim)
%SUBPAD Index into array and pad with NaNs for invalid subscripts.
% Usage:
%   Y = subpad(X, subs)
%   [Y, Xind, Yind] = subpad(X, subs, dim)
% 
% Args:
%   X: data matrix
%   subs: linear indices across dimension
%   dim: dimension to index across (default: 1)
%
% Returns:
%   Y: indexed subset of X
%   Xind: linear indices for valid X data
%   Yind: linear indices for valid Y data
% 
% See also: indpad 

if nargin < 3 || isempty(dim)
    dim = 1;
end

sz = size(X);
valid_subs = subs >= 1 & subs <= sz(dim);

Xall_subs = repmat({':'},size(sz));
Xall_subs{dim} = subs(valid_subs);
Xind = sub2allind(sz, Xall_subs{:});

Ysz = sz;
Ysz(dim) = numel(subs);

Yall_subs = repmat({':'},size(Ysz));
Yall_subs{dim} = find(valid_subs);
Yind = sub2allind(Ysz, Yall_subs{:});

Y = NaN(Ysz);
Y(Yind) = X(Xind);

end
