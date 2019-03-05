function Y = stackparfun(f, X, cellOutput)
%STACKPARFUN Applies a function to each layer in a stack in parallel.
% Usage:
%   Y = stackparfun(f, X)
%   Y = stackparfun(f, X, true) % cell output
%
% See also: stackfun

if nargin < 3; cellOutput = false; end

is3d = false;
if ndims(X) == 3; X = permute(X,[1 2 4 3]); is3d = true; end

% X = validate_stack(X);
N = size(X, 4);

Y = cell(N, 1);
parfor i = 1:N
    Y{i} = f(X(:,:,:,i));
end

if cellOutput; return; end

sameSize = cellfun(@(x) isequal(size(Y{1}), size(x)), Y);
if all(sameSize)
    if all(cellfun(@isscalar, Y))
        Y = cat(1, Y{:});
    elseif is3d && all(cellfun(@(y)size(y,3)==1,Y))
        Y = cat(3, Y{:});
    else
        Y = cat(4, Y{:});
    end
end

end
