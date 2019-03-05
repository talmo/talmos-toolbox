function X_hat = decode_pca(pcs,z,D)
if nargin < 3 || isempty(D); D = 1:size(z,2); end
X_hat = (z * pcs.coeff(:,D)') + pcs.mu;
end