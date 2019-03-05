function C = bsxadd(A, B)
%BSXADD Shortcut for bsxfun(@plus, A, B).
%
% Usage:
%   C = bsxadd(A, B)
%
% Example:
%   offset_pts = bsxadd(pts, [dx, dy])
%
% See also: bsxfun

C = bsxfun(@plus, A, B);

end

