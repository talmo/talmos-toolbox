function varargout = stackparfun2(fun, X, varargin)
%STACKPARFUN2 Applies a function to each layer in a stack in parallel.
% Usage:
%   out = stackparfun2(fun, X)
%   out = stackparfun2(fun, X1, X2, X3, ...)
%   [out1, out2, out3, ...] = stackparfun2(_)
%   ... = stackparfun2(..., 'UniformOutput', false)
%
% Args:
%   fun: handle to a function of the form:
%        - fun(X(:,:,:,i)), or 
%        - fun(X1(:,:,:,i), X2(:,:,:,i), X3(:,:,:,i), ...)
%   X1, X2, X3, ...: 4-D stacks with the same size in dimension 4
% 
% Returns:
%   out1, out2, out3, ...: outputs of the function
% 
% See also: cellparfun, parfeval

% Check for cell output parameter
cellOutput = false;
uniParamIdx = find(strcmpi(varargin,'UniformOutput'),1);
if ~isempty(uniParamIdx) && numel(varargin) > uniParamIdx && islogical(varargin{uniParamIdx+1})
    cellOutput = ~varargin{uniParamIdx+1};
    varargin(uniParamIdx:uniParamIdx+1) = [];
end

% Concatenate inputs
X = [{X} varargin];

% Keep track of outputs
nout = max(nargout, 1);

% Create parallel jobs
N = size(X{1},4);
for i = 1:N
    args = cf(@(x) x(:,:,:,i), X); % slice
    futures(i) = parfeval(fun, nout, args{:});
end

% Retrieve outputs
varargout = repmat({cell(N,1)},1,nout);
out = cell(1,nout);
for i = 1:N
    [idx,out{1:nout}] = fetchNext(futures);
    for j = 1:nout
        varargout{j}{idx} = out{j};
    end
end

% Concatenate outputs
if ~cellOutput
    for i = 1:numel(varargout)
        sz = cf(@size,varargout{i});
        
        % Check that all outputs were the same size
        sameSize = cellfun(@(x)isequal(x,sz{1}),sz);
        if ~all(sameSize); continue; end
        
        if prod(sz{1}) == 1 % scalar
            varargout{i} = cellcat(varargout{i},1);
        else % N-D
            varargout{i} = cellcat(varargout{i},4);
        end
    end
%     varargout = cf(@(x)cellcat(x,4), varargout);
end


end

