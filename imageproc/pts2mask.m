function BW = pts2mask(pts, maskSize, useConvHull)
%PTS2MASK Convenience wrapper for poly2mask.
% Usage:
%   BW = pts2mask(pts) % uses bounding box of points
%   BW = pts2mask(pts, maskSize)
%   BW = pts2mask(pts, maskSize, true) % use convex hull of points
%
% See also: poly2mask, mask2pts

pts = validatepoints(pts);
if nargin < 3 || isempty(useConvHull); useConvHull = false; end
if useConvHull; pts = convhullpts(pts); end
if nargin < 2 || isempty(maskSize)
    maskSize = max(pts);
end

BW = poly2mask(pts(:,1), pts(:,2), maskSize(1), maskSize(2));


end

