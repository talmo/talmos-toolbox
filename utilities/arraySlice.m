function S = arraySlice(A, I, d)
%ARRAYSLICE 
% Usage:
%   arrayslice(A, I, d)

c = arrayfun(@(x)1:x,arrayfun(@(y)size(A,y),1:max(ndims(A), d)),'Un',0);
c{d} = I;
S = A(c{:});


end
