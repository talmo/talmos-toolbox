function BWcc = bwccmasks(BW,conn)
%BWCCMASKS Returns a stack with a connected component in each slice.
% Usage:
%   BWcc = bwccmasks(BW)
%
% See also: bwlabel, bwconncomp
if nargin < 2; conn = 8; end
if islogical(BW)
    L = bwlabel(BW,conn);
elseif isnumeric(BW)
    L = BW;
else
    error('BW must be logical or a numeric labels matrix.')
end
BWcc = af(@(i) L == i, setdiff(unique(L), 0));

if numel(BWcc) > 1
    BWcc = validate_stack(BWcc, true);
elseif numel(BWcc) == 1
    BWcc = BWcc{1};
else
    BWcc = [];
end
    

end

