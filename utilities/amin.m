function [M, I] = amin(X)
%AMIN Returns the min of the entire array.
% Usage:
%   M = amin(X)
%   [M, I] = amin(X)
% 
% Args:
%   X: numeric array
%
% Returns:
%   M: minimum value in the entire array
%   I: index of the minimum value in the entire array
%
% Note: This is equivalent to min(X(:))
% 
% See also: amax, arange

[M, I] = min(X(:));

end

