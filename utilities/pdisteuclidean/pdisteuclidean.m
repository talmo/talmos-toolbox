%PDISTEUCLIDEAN Computes the pairwise Euclidean distance of a matrix.
% Usage:
%   D = pdisteuclidean(X)
%
% Args:
%   X: 2d double of size [M,N] -- distances will be computed between rows
%
% Returns:
%   D: 2d double of size [M,M]
%
% Note: This function computes the equivalent to:
%   D = squareform(pdist(X))
% But it is implemented using fast BLAS routines.
%
% See also: pdist, squareform