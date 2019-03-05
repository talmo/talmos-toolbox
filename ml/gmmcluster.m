function [C, mu, gmm, posterior] = gmmcluster(X, k, varargin)
%GMMCLUSTER Clusters data using a GMM.
% Usage:
%   C = gmmcluster(X, k)
%   C = gmmcluster(X, k, ...) % fitgmdist params
%   [C, mu, gmm, posterior] = gmmcluster(X, k)
%
% Args:
%   X: NxM numeric float, where rows are samples and columns are features
%   k: number of components to fit
%   Also accepts any fitgmdist parameter.
%  
% Returns:
%   C: Nx1 vector of cluster indices
%   mu: kx1 vector of component means in ascending order
%   gmm: gmdistribution object of the fitted model
%   posterior: Nxk posterior probabilities for each sample in X
%
% See also: fitgmdist, gmdistribution, fitellipsegmm

% Fit the GMM
gmm = fitgmdist(X, k, varargin{:});

% Pull out component means and sort in ascending order
[mu, order] = sortrows(gmm.mu);

% Cluster and reorder
C = gmm.cluster(X);
C(~isnan(C)) = order(C(~isnan(C)));

% Posterior
if nargout > 3
    posterior = gmm.posterior(X);
    posterior = posterior(:,order);
end

end

