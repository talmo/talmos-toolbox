function mask = sub2mask(siz,varargin)
%SUB2MASK Combine subscripts and logical indexing to a logical mask.
%   SUB2MASK is used to simplify the access of multidimensional arrays.
%
%   MASK = SUB2MASK(SIZ, varargin) returns a logical mask of size SIZ,
%   according to the subscript or logical indices provided by varargin.
%
%   Example: We access all layers of a 3D array according to a diagonal
%   mask:
%
%   A = rand(10,10,4);
%   A(SUB2MASK(size(A),eye(10)~=0,:));
%   
%   This could be simplified via an anonymous function:
%
%   I = @(A,varargin) SUB2MASK(size(A),varargin{:});
%   A(I(A,eye(10)~=0,:))
%
%   I = @(varargin) SUB2MASK(size(A), varargin{:});
%   A(I(eye(10)~=0,:))

mask = true;
d = 1;
for k = 1:numel(varargin)
    if isequal(varargin{k},':')
        varargin{k} = true(siz(d),1);
    elseif ~islogical(varargin{k})
        varargin{k} = accumarray(varargin{k}(:),1,[siz(d),1]);
    end
    mask = bsxfun(@and, mask, reshape(varargin{k},[ones(1,d-1), size(varargin{k})]));
    d = d + numDims(varargin{k});
end
end

function d = numDims(A)
% Returns number of dimensions, treats 1-by-n or n-by-1 arrays as vectors
if isrow(A) || iscolumn(A)
    d = 1;
else
    d = numel(size(A));
end
end