function idx = range2idx(A, cell_output)
%RANGE2IDX Returns the indices specified by the rows in A.
% Usage:
%   idx = range2idx(A)
%
% Args:
%   A: N x 2 matrix of indices

if nargin < 2; cell_output = true; end

if isempty(A)
    idx = [];
%     if cell_output; idx = {idx}; end
    return
end

idx = arrayfun(@(i, j) i:j, A(:, 1), A(:, 2), 'UniformOutput', false);
% idx = unique([idx{:}]);
if ~cell_output
    idx = [idx{:}];
else
    if numel(idx) == 1
        idx = idx{1};
    end
end

end

