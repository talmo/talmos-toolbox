function X = stackfun(f, X, cellOutput)
%STACKFUN Applies a function to each layer in a stack.
%   Y = stackfun(f, X)
%   Y = stackfun(f, X, true) % cell array output

if nargin < 3; cellOutput = false; end

X = validate_stack(X);
N = size(X, 4);

% Run first to see if output is same size as input
Y_1 = f(X(:,:,:,1));
inPlace = isequal(size(X(:,:,:,1)), size(Y_1));

if inPlace && ~cellOutput
    X(:,:,:,1) = Y_1;
    for i = 2:N
        X(:,:,:,i) = f(X(:,:,:,i));
    end
else
    Y = cell(N,1);
    Y{1} = Y_1; % save first
    for i = 2:N
        Y{i} = f(X(:,:,:,i));
    end
    X = Y;
    
    % Still try to concatenate if cell output not requested and all results
    % are of the same size
    sameSize = cellfun(@(x) isequal(size(Y_1), size(x)), X);
    if ~cellOutput && all(sameSize)
        if all(cellfun(@isscalar, X))
            X = cat(1, X{:});
        else
            X = cat(4, X{:});
        end
    end
end

end

