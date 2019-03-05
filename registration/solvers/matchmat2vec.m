function b = matchmat2vec(B)
%MATCHMAT2VEC Converts a sparse match matrix to an Mx3 vector of points.

b = reshape(nonzeros(B'), 3, nnz(B) / 3)';
end

