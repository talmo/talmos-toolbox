function varargout = label2bw(L, fullRange)
%LABEL2BW Label matrix in, binary masks out!
% Usage:
%   BW = label2bw(L)
%   BW = label2bw(L, true) % returns empty slices
%   [BW1, BW2, ...] = label2bw(L)
%
% See also: bwstack2label

if nargin < 2; fullRange = false; end

if fullRange
    idx = 1:amax(L);
else
    idx = unique(L(L > 0));
end

BWs = af(@(i) L == i, idx);

if nargout < 2
    varargout = {cellcat(BWs,4)};
else
    varargout = BWs;
end

end

