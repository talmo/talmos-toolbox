function [Y, inX] = indpad(X, ind, padval)
%INDPAD Index into array with padding for out of bounds indices.
% Usage:
%   [Y, inX] = indpad(X, ind, padval)
% 
% Args:
%   X: array
%   ind: linear indices
%   padval: scalar value to pad with (default: NaN)
% 
% Returns:
%   Y: array of the same size as ind
%   inX: logical of the same size as ind that is true for values in X
% 
% See also: padarray, catpadarr

if nargin < 3 || isempty(padval); padval = NaN; end

inX = ind >= 1 & ind <= numel(X);
Y = repmat(padval, size(inX));
Y(inX) = X(ind(inX));

end
