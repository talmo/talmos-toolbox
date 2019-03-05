function [Q,Z] = findQ2(X)
%FINDQ2 Compute the Q and Z terms.

Q = 1 ./ (1 + pdisteuclidean(X).^2);
Q(1:size(Q,1)+1:end) = 0;
Z = sum(Q(:)); Q = Q./Z;

end

