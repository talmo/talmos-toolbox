function [X, lambda, M, PCs, expVar] = tsne_pca(X, keepDims, normalize, visualize)
%TSNE_PCA Compute PCA using the implementation in original tSNE.
% Usage:
%   X = tsne_pca(X)
%   [X, lambda, M, PCs, expVar] = tsne_pca(X, keepDims, normalize, visualize)
% 
% Args:
%   X:
%       Data matrix where rows are observations and columns are features
%   keepDims: (default = 0.9)
%       The dimensions (principal components) to keep
%       If keepDims < 1, keeps enough PCs to reach the explained variance
%       if keepDims is a vector, keeps the specified dimensions
%   normalize: (default = true)
%       Set to false if data is already normalized
%   visualize: (default = true)
%       Plots the explained variances of the principal components
% 
% Returns:
%   X:
%       Projection of the original data matrix onto kept PCs
%   lambda:
%       Eigenvalues of the covariance matrix decomposition
%   M:
%       Eigenvectors of the covariance matrix decomposition
%   PCs:
%       The principal component numbers, in order of explained variance
%   expVar:
%       Explained variances of the principal components
% 
% See also: tsne

if ~exist('visualize', 'var') || isempty(visualize)
    visualize = false;
end
if ~exist('normalize', 'var') || isempty(normalize)
    normalize = true;
end
if ~exist('keepDims', 'var') || isempty(keepDims)
    keepDims = 0.9;
end

t_pca = tic; szX = size(X);

% Mean normalize input data
if normalize
    X = X - min(X(:));
    X = X / max(X(:));
    X = bsxfun(@minus, X, mean(X, 1));
end

% Compute covariance matrix
if size(X, 2) < size(X, 1)
    C = X' * X;
else
    C = (1 / size(X, 1)) * (X * X');
end

% Compute eigenvectors, eigenvalues (diagonal)
[M, lambda] = eig(C);

% Vectorize and sort eigenvalues
[lambda, ind] = sort(diag(lambda), 'descend');

% Compute explained variance
expVar = lambda ./ sum(lambda);

% Heuristic for # of dimensions to keep
if isscalar(keepDims)
    if keepDims < 1.0
        cumExpVar = cumsum(expVar);
        minExpVar = keepDims;
        keepDims = find(cumExpVar >= minExpVar, 1);
    end
    PCs = 1:keepDims;
else
    PCs = keepDims;
end
expVar = expVar(PCs);

% Drop extra principal components
M = M(:,ind(PCs));
lambda = lambda(PCs);

% Project original data
if ~(size(X, 2) < size(X, 1))
    M = bsxfun(@times, X' * M, (1 ./ sqrt(size(X, 1) .* lambda))');
end
X = bsxfun(@minus, X, mean(X, 1)) * M;

t_pca = toc(t_pca); fprintf('Computed the PCA (data: %d x %d). [%.2fs]\n', szX(1), szX(2), t_pca);
fprintf('Kept %d/%d dimensions: %.2f%% variance explained.\n', numel(PCs), szX(2), sum(expVar) * 100)

if visualize
    % Plot explained variance
    figure
    [ax,b,p] = plotyy(1:numel(PCs), expVar, 1:numel(PCs), cumsum(expVar), 'bar', 'plot');

    xlabel('Principal Components')
    ylabel(ax(1), 'Explained variance (component)')
    ylabel(ax(2), 'Explained variance (cumulative)')
    
    p.LineWidth = 2.0;
    
    axis(ax, 'tight')
    
    % Label X axis using PC number
    xLabels = cellstr(num2str(PCs(ax(1).XTick)'));
    ax(1).XTickLabel = xLabels;
    ax(2).XTickLabel = xLabels;
    
    % Fix Y ticks
    ax(1).YTickMode = 'auto';
    ax(2).YTickMode = 'auto';
    
    drawnow
end

end

