function [X_train, X_test, idx_train, idx_test] = traintestsplit(X, N_train, dim, shuffle)
%TRAINTESTSPLIT Split an array into training and testing set.
% Usage:
%   [X_train, X_test, idx_train, idx_test] = traintestsplit(X, N_train, dim, shuffle)
% 
% See also: grp2cell, arr2cell, chunk2cell, cellcat

if nargin < 3 || isempty(dim); dim = 1; end
if nargin < 4 || isempty(shuffle); shuffle = true; end
if N_train < 1; N_train = round(N_train * size(X,dim)); end

idx = 1:size(X,dim);
if shuffle; idx = randperm(size(X,dim)); end

idx_train = idx(1:N_train);
idx_test = idx(N_train+1:end);

subs = repmat({':'},1,ndims(X));
subs{dim} = idx_train;
X_train = X(subs{:});

subs{dim} = idx_test;
X_test = X(subs{:});
end
