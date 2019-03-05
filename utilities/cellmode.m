function M = cellmode(C)
%CELLMODE Returns the most frequent element in a cell array of strings.
% Usage:
%   M = cellmode(C)
%
% See also: mode

if isempty(C) || ~iscellstr(C)
    error('Must specify a non-empty cell array of strings.')
end

[U, ~, idx] = unique(C);
M = U(mode(idx));
M = M{1};

end

