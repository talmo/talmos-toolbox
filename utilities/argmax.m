function idx = argmax(X, dim)
%ARGMAX Returns the index at which the max is found.
% Usage:
%   idx = argmax(X)
%   idx = argmax(X, dim)

if isvector(X)
    [~, idx] = max(X);
else
    if nargin < 2; dim = 1; end
    [~, idx] = max(X, [], dim);
end

end

