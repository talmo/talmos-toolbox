function L = bwstack2label(S)
%BWSTACK2LABEL Converts a stack of binary masks to a label matrix.
% Usage:
%   L = bwstack2label(S)
% 
% See also: bwlabel, bwccmasks

S = validate_stack(S);
L = sum(S .* permute(1:size(S,4), [1 3 4 2]),4);

end

