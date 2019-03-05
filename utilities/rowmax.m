function [M, I] = rowmax(X, absolute)
%ROWMAX Returns the max of each row of an array.
% Usage:
%   [M, I] = rowmax(X)
%   [M, I] = rowmax(X, true) % max of absolute value
%
% See also: max, argmax

if nargin < 2; absolute = false; end

if absolute
    I = sub2ind(size(X), (1:size(X,1))', argmax(abs(X),2));
else
    I = sub2ind(size(X), (1:size(X,1))', argmax(X,2));
end

M = X(I);

end

