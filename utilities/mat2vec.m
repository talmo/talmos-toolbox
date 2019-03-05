function V = mat2vec(X, wide)
%MAT2VEC Returns the matrix as a vector.
% Usage:
%V = mat2vec(X) % N X 1 vector
%V = mat2vec(X, true) % 1 X N vector

if nargin < 2
    wide = false;
end

if wide
    V = reshape(X, 1, []);
else
    V = reshape(X, [], 1);
end

end

