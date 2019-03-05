function varargout = mask2pts(BW)
%MASK2PTS Returns a set of points of a logical image.
% Usage:
%   [X, Y] = mask2pts(BW)
%   [X, Y, Z] = mask2pts(BW)
%   pts = mask2pts(BW)
%
% See also: poly2mask

N = ndims(BW);
out = wrap(@()ind2sub(size(BW),find(BW)),1:N);

if N > 1 % [I,J] -> [X,Y]
    out(1:2) = out([2 1]);
end

varargout = out;
if nargout < 2; varargout = {cellcat(out,2)}; end

end

