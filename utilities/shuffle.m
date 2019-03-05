function [X2,idx] = shuffle(X,dim)
%SHUFFLE Shuffle elements of an array.
% Usage:
%   [X2,idx] = shuffle(X) % along all elements
%   [X2,idx] = shuffle(X,dim) % along a dimension
%   [X2,idx] = shuffle(X,[]) % along all elements

% if isscalar(X); X = 1:X; end
% if nargin < 2; dim = find(size(X) > 1,1); end
if nargin < 2; dim = []; end

if isempty(dim)
    idx = randperm(numel(X));
    X2 = X(idx);
else
    idx = randperm(size(X,dim));
    subs = repmat({':'},ndims(X)); subs{dim} = idx;
    ind = sub2allind(size(X),subs{:});
    X2 = X(ind);
end
end

