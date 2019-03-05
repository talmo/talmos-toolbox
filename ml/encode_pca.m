function z = encode_pca(pcs, X, D)
%ENCODE_PCA Description
% Usage:
%   encode_pca(pcs, X)
% 
% Args:
%   pcs: 
%   X: 
% 
% See also: 

if ndims(X) > 2; X = stack2vecs(X); end
if nargin < 3 || isempty(D); D = 1:size(pcs.coeff,2); end

z = (X - pcs.mu) * pcs.coeff(:,D);

end
