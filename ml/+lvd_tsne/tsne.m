function ydata = tsne(X, labels, no_dims, initial_dims, perplexity, max_iter, viz, skipPCA)
%TSNE Performs symmetric t-SNE on dataset X
%
%   mappedX = tsne(X, labels, finalDims, numPCsToKeep, perplexity, max_iter, viz)
%   mappedX = tsne(X, labels, initial_solution, perplexity, max_iter, viz)
%
% The function performs symmetric t-SNE on the NxD dataset X to reduce its 
% dimensionality to no_dims dimensions (default = 2). The data is 
% preprocessed using PCA, reducing the dimensionality to initial_dims 
% dimensions (default = 30). Alternatively, an initial solution obtained 
% from an other dimensionality reduction technique may be specified in 
% initial_solution. The perplexity of the Gaussian kernel that is employed 
% can be specified through perplexity (default = 30). The labels of the
% data are not used by t-SNE itself, however, they are used to color
% intermediate plots. Please provide an empty labels matrix [] if you
% don't want to plot results during the optimization.
% The low-dimensional data representation is returned in mappedX.
%
%
% (C) Laurens van der Maaten, 2010
% University of California, San Diego


    if ~exist('labels', 'var') || isempty(labels)
        labels = 1:size(X,1);
    end
    if ~exist('no_dims', 'var') || isempty(no_dims)
        no_dims = 2;
    end
     if ~exist('initial_dims', 'var') || isempty(initial_dims)
        initial_dims = min(50, size(X, 2));
    end
    if ~exist('perplexity', 'var') || isempty(perplexity)
        perplexity = 30;
    end
    if ~exist('max_iter', 'var') || isempty(max_iter)
        max_iter = 750;
    end
    if ~exist('viz', 'var') || isempty(viz)
        viz = 1;
    end
    if ~exist('skipPCA', 'var') || isempty(skipPCA)
        skipPCA = 0;
    end
    
    % First check whether we already have an initial solution
    if numel(no_dims) > 1
        initial_solution = true;
        ydata = no_dims;
        no_dims = size(ydata, 2);
        perplexity = initial_dims;
    else
        initial_solution = false;
    end
    
    % Normalize input data
    X = X - min(X(:));
    X = X / max(X(:));
    X = bsxfun(@minus, X, mean(X, 1));
    
    % Perform preprocessing using PCA
    if ~skipPCA && ~initial_solution
        display('Preprocessing with PCA...')
        X = tsne_pca(X, initial_dims, false, viz);
    end
    
    % Compute pairwise distance matrix
    sum_X = sum(X .^ 2, 2);
    D = bsxfun(@plus, sum_X, bsxfun(@plus, sum_X', -2 * (X * X')));
    
    % Compute joint probabilities
    P = d2p(D, perplexity, 1e-5);                                           % compute affinities using fixed perplexity
    clear D
    
    % Run t-SNE
    if initial_solution
        ydata = tsne_p(P, labels, ydata, max_iter, viz);
    else
        ydata = tsne_p(P, labels, no_dims, max_iter, viz);
    end
    