function [cropped, crop_rect, crop_mask] = bwcrop(BW, crop_rect)
%BWCROP Crops a mask to the bounding box of foreground pixels.
% Usage:
%   cropped = bwcrop(BW)
%   cropped = bwcrop(L) % labels
%   [cropped, crop_rect, crop_mask] = bwcrop(_)
%
% Args:
%   BW: logical 2-D mask, will be cropped to true pixels
%   L: labels (numeric) 2-D matrix, will be cropped to pixels > min(L(:))
% 
% Returns:
%   cropped: 2-D matrix of the same type as input
%   crop_rect: [x0, y0, width, height] rectangle defining cropping region
%   crop_mask: 2-D logical matrix that is true where pixels were kept
%   
% See also: imcrop, bwlabel, boundingBox, mask2pts

BW0 = BW;
if ~islogical(BW)
    BW = BW0 > min(BW0(:));
end

if nargin > 1 % cropping specified
    if islogical(crop_rect) % mask
        crop_mask = crop_rect;
        [~,crop_rect] = bwcrop(crop_mask);
    end
else % find crop_rect
    [X,Y] = mask2pts(BW);

    x0 = min(X);
    y0 = min(Y);
    width = max(X) - x0;
    height = max(Y) - y0;

    crop_rect = [x0, y0, width, height];
end

I = crop_rect(2):(crop_rect(2) + crop_rect(4));
J = crop_rect(1):(crop_rect(1) + crop_rect(3));

cropped = BW0(I, J);


if nargout > 2
    crop_mask = false(size(BW));
    crop_mask(I,J) = true;
end

end

