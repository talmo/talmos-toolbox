function Xn = norm2unit(X)
%NORM2UNIT Scales the range of X to [0, 1].
% Usage:
%   Xn = norm2unit(X)

Xn = X - min(X(:));
Xn = Xn ./ max(Xn(:));

end

