function [folds] = getcvfolds(N,k,seed)
% function [folds] = getcvfolds(N,k,seed)
% 
% Creates a random folds matrix suitable for cross-validation.
% folds(i,j) = 1 when the i'th observation should be included in the j'th
% fit fold, while folds(i,j) = 0 when the observation should be included in
% the j'th validation fold. By construction the i'th observation is in only
% one validation fold.
%
% N: number of observations (ie: length(y))
% k: number of cross-validation folds
% seed: (optional) a seed to reset the random number generator with
%
% See also CVGLMFITSPARSEPRIOR
%
    if nargin > 2
        %Re-seed random number generator
        rand('twister',seed);
    end
    folds = ones(N,k) == 1;
    %Shuffle integers from 1 to N
    [discard idx] = sort(rand(N,1));
    rg = [0,ceil((1:k)*N/k)];
    for ii = 1:k
        folds(idx(rg(ii)+1:rg(ii+1)),ii) = 0;
    end
    folds = folds == 1;
end
