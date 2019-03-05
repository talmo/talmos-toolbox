function B = catpadarr(dim, varargin)
%CATPADARR Concatenates variable sized arrays along specified dimension by padding.
% Usage:
%   B = catpadarr(dim, A1, A2, ...)
%   B = catpadarr(dim, {A1, A2, ...})
%   B = catpadarr(dim, {A1, A2, ...}, padval, direction)
% 
% Args:
%   dim: dimension along which to concatenate
%   A1, A2, ...: arrays with all dimensions the same except dim
%   padval: value or method for padding (default: NaN)
%           methods: 'circular', 'replicate', 'symmetric'
%   direction: 'pre', 'post', 'both' (default: 'post')
%
% Returns:
%   B: concatenated array of the same type as padval if method isn't
%       specified, otherwise retains the same class
%
% Note: Use the cell array form of the input in order to specify the last
% two arguments.
% 
% See also: padarray, catpad

padval = [];
direction = [];
if iscell(varargin{1})
    B = varargin{1};
    if numel(varargin) > 1 && ~iscell(varargin{2}); padval = varargin{2}; end
    if numel(varargin) > 2 && ischar(varargin{3}); direction = varargin{3}; end
else
    B = varargin;
end
if isempty(padval)
    padval = NaN;
    if isinteger(B{1}); padval = cast(0,class(B{1})); end
end
if isempty(direction); direction = 'post'; end

% Was padding method specified?
isMethod = ischar(padval) && any(strcmpi(padval,{'circular','replicate','symmetric'}));

% Find maximum dimensionality
D = max(cellfun(@ndims, B));

% Find sizes along each dimension
N = cellfun(@(b)arrayfun(@(d)size(b,d),1:D), B, 'UniformOutput', false);
N = cat(1,N{:});
N(:,dim) = 0; % we don't pad the selected dimension
M = max(N); % max size across each dimension
M = max(M,1); % make sure zero dims have at least 1 element

for i = 1:numel(B)
    % Check class
    if ~isMethod && ~isa(B{i}, class(padval))
        B{i} = cast(B{i}, class(padval));
    end
    
    % Compute pad size
    padsize = M - N(i,:);
    
    % Pad
    B{i} = padarray(B{i},padsize,padval,direction);
end

% Concatenate
B = cat(dim, B{:});

end

