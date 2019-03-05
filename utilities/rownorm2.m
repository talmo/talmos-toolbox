function [n, norms] = rownorm2(A)
%ROWNORM2 Calculates the 2-norm for every row in A.
% Usage:
%    n = rownorm2(A)
%    [n, norms] = rownorm2(A)

norms = sqrt(sum(A .^2, 2));    % 2-norm of every row
n = sum(norms) / length(norms); % average norm
end

