function N = depth(X)
%DEPTH Returns the size of the last dimension of an array.
% Usage:
%   N = depth(X)
% 
% Args:
%   X: any array
% 
% Returns:
%   N: size of last dimension of an array
%
% Note: this is just a shortcut for size(X,ndims(X))
% 
% See also: length, width, height, size, numel, ndims

N = size(X,ndims(X));

end
