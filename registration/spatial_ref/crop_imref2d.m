function cropped_R = crop_imref2d(R, region)
%CROP_IMREF2D Returns a cropped region of the spatial referencing object.
%
% Usage:
%   cropped_R = crop_imref2d(R, region)
%
% Args:
%   R must be an imref2d object.
%   region must specify a rectangle in world coordinates.
%
% Region types:
%   Bounding box: 5x2 matrix
%   Limits: 2x2 matrix, first row is XLimits, second row is YLimits
%   Position + size: 1x4 matrix, [x, y, width, height]
%
% See also: imref2d, ref_bb, sz2bb, imload_tile_region

if all(size(region) == [5, 2])
    xlims = [min(region(:,1)), max(region(:,1))];
    ylims = [min(region(:,2)), max(region(:,2))];
elseif all(size(region) == [2, 2])
    xlims = region(1,:);
    ylims = region(2,:);
elseif all(size(region) == [1, 4])
    xlims = [region(1), region(1) + region(3)];
    ylims = [region(2), region(2) + region(4)];
end

[I, J] = R.worldToSubscript(xlims, ylims);
sz = [diff(I), diff(J)];

cropped_R = imref2d(sz, R.PixelExtentInWorldX, R.PixelExtentInWorldY);
cropped_R.XWorldLimits = xlims;
cropped_R.YWorldLimits = ylims;
end

