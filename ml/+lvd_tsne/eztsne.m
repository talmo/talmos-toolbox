function mX = eztsne(X, labels)
%EZTSNE Manifold embedding -- quick and easy!
% Usage:
%   eztsne(X)
%   mX = eztsne(X)
%   mX = eztsne(X, labels)
%
% See also: tsne, tsne_pca

% Params
if nargin < 2
    labels = ones(size(X,1),1);
end
no_dims = 2; % target dimensions
initial_dims = 15;
perplexity = 5;
max_iter = 1000;

% Go!
mX = tsne(X, labels, no_dims, initial_dims, perplexity, max_iter);

% Visualize
figure
scatter(mX(:,1), mX(:,2), 5, labels, 'filled')
title(sprintf('t-SNE Embedding (n = %d)', size(mX,1)))
legend(strsplit(num2str(unique(labels(:)'))))

if nargout < 1
    clear mX
end

end

