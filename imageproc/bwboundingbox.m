function BWbb = bwboundingbox(BW)
%BWBOUNDINGBOX Returns a mask of the bounding box of the pixels in BW.
% Usage:
%   BWbb = bwboundingbox(BW)
% 
% Args:
%   BW: logical image
%
% Returns:
%   BWbb: logical of the same size as BW that is true within the bounding
%         box of the true pixels in BW
% 
% See also: bwcrop, boundingBox

if ~islogical(BW); BW = BW > 0; end

[X,Y] = mask2pts(BW);

X = alims(X);
Y = alims(Y);

BWbb = false(size(BW));
BWbb(Y(1):Y(2), X(1):X(2)) = true;


end
