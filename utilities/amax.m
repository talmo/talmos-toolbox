function [M, I] = amax(X)
%AMAX Returns the max of the entire array.
% Usage:
%   M = amax(X)
%   [M, I] = amax(X)
% 
% Args:
%   X: numeric array
%
% Returns:
%   M: maximum value in the entire array
%   I: index of the maximum value in the entire array
%
% Note: This is equivalent to max(X(:))
% 
% See also: amin, arange 

[M, I] = max(X(:));

end

