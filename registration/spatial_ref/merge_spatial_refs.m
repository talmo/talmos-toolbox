function R_output = merge_spatial_refs(Rs, fix_resolution)
%MERGE_SPATIAL_REFS Combine several spatial referencing objects into one.
% Usage:
%   R_output = merge_spatial_refs(Rs)
%   R_output = merge_spatial_refs(Rs, fix_resolution) % default = false
%
% See also: tform_spatial_ref

if ~iscell(Rs)
    Rs = {Rs};
end
if nargin < 2
    fix_resolution = false;
end
if ~all(cellfun(@(R) isa(R, 'imref2d'), Rs))
    error('Input must be imref2d objects.')
end

outputWorldLimitsX = [min(cellfun(@(R) R.XWorldLimits(1), Rs)),...
                      max(cellfun(@(R) R.XWorldLimits(2), Rs))];

outputWorldLimitsY = [min(cellfun(@(R) R.YWorldLimits(1), Rs)),...
                      max(cellfun(@(R) R.YWorldLimits(2), Rs))];
                  
if fix_resolution
    goalResolutionX = 1.0;
    goalResolutionY = 1.0;
else
    goalResolutionX = min(cellfun(@(R) R.PixelExtentInWorldX, Rs));
    goalResolutionY = min(cellfun(@(R) R.PixelExtentInWorldY, Rs));
end

widthOutputRaster  = ceil(diff(outputWorldLimitsX) / goalResolutionX);
heightOutputRaster = ceil(diff(outputWorldLimitsY) / goalResolutionY);

% Adjust world limits to get precise target resolution
xNudge = (widthOutputRaster*goalResolutionX-diff(outputWorldLimitsX))/2;
yNudge = (heightOutputRaster*goalResolutionY-diff(outputWorldLimitsY))/2;
outputWorldLimitsX = outputWorldLimitsX + [-xNudge xNudge];
outputWorldLimitsY = outputWorldLimitsY + [-yNudge yNudge];

R_output = imref2d([heightOutputRaster, widthOutputRaster]);
R_output.XWorldLimits = outputWorldLimitsX;
R_output.YWorldLimits = outputWorldLimitsY;

end

