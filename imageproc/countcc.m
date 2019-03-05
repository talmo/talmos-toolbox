function N = countcc(BW,conn)
%COUNTCC Returns the number of connected components in an image.
% Usage:
%   N = countcc(BW)
%   N = countcc(BW, conn)
%
% Args:
%   BW: logical image
%   conn: connectivity (default: 8 or 26)
%
% See also: bwconncomp, regionprops

if nargin < 2
    conn = 8;
    if ndims(BW) == 3; conn = 26; end
end

CC = bwconncomp(BW, conn);
N = uint32(CC.NumObjects);

end

