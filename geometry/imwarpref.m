function R_out = imwarpref(R_in, tform)
%imwarpref Applies a transform to a spatial referencing object.
% Usage:
%   R_out = imwarpref(R_in, tform)
% 
% From: images.spatialref.internal.applyGeometricTransformToSpatialRef
%
% See also: imref2d, imref3d, imwarp


%   FOR INTERNAL USE ONLY -- This function is intentionally
%   undocumented and is intended for use only within other toolbox
%   classes and functions. Its behavior may change, or the feature
%   itself may be removed in a future release.
%
%   Rout = resampleImageToNewSpatialRef(R_in,tform) takes a spatial
%   referencing object Rin and a geometric transformation tform. The
%   output Rout is a spatial referencing object. The world limits of Rout
%   are determined by forward mapping the world limits of Rin according to
%   tform. The ImageSize of Rout is determined by scaling Rin.ImageSize by
%   the scale factors in tform.

% Copyright 2012 The MathWorks, Inc.

is2d = ~isa(R_in,'imref3d');
if is2d
    
    [XWorldLimitsOut,YWorldLimitsOut] = outputLimits(tform,R_in.XWorldLimits,R_in.YWorldLimits);
    
    % Fix the output resolution to be the same as the input resolution in
    % each dimension.
    outputResolutionX = R_in.PixelExtentInWorldX;
    outputResolutionY = R_in.PixelExtentInWorldY;
    
    % Use ceil to provide grid that will accomodate world limits at roughly the
    % target resolution.
    numCols = ceil(diff(XWorldLimitsOut) / outputResolutionX);
    numRows = ceil(diff(YWorldLimitsOut) / outputResolutionY);
    
    % If the world limits divided by the output resolution are not
    % integrally valued, we adjust the world limits such that we exactly
    % honor the target output resolution. We adjust all four corners such
    % that the center of the image remains fixed in world coordinates.
    xNudge = (numCols*outputResolutionX-diff(XWorldLimitsOut))/2;
    yNudge = (numRows*outputResolutionY-diff(YWorldLimitsOut))/2;
    XWorldLimitsOut = XWorldLimitsOut + [-xNudge xNudge];
    YWorldLimitsOut = YWorldLimitsOut + [-yNudge yNudge];
   
    % Construct output referencing object with desired outputImageSize and
    % world limits.
    outputImageSize = [numRows numCols];
    R_out = imref2d(outputImageSize,XWorldLimitsOut,YWorldLimitsOut);
    
else
    
    [XWorldLimitsOut,YWorldLimitsOut,ZWorldLimitsOut] = outputLimits(tform,...
        R_in.XWorldLimits,...
        R_in.YWorldLimits,...
        R_in.ZWorldLimits);
    
    % Fix the output resolution to be the same as the input resolution in
    % each dimension.
    outputResolutionX = R_in.PixelExtentInWorldX;
    outputResolutionY = R_in.PixelExtentInWorldY;
    outputResolutionZ = R_in.PixelExtentInWorldZ;

    % Use ceil to provide grid that will accomodate world limits at roughly the
    % target resolution.
    numCols     = ceil(diff(XWorldLimitsOut) / outputResolutionX);
    numRows     = ceil(diff(YWorldLimitsOut) / outputResolutionY);
    numPlanes   = ceil(diff(ZWorldLimitsOut) / outputResolutionZ);

    % If the world limits divided by the output resolution are not
    % integrally valued, we adjust the world limits such that we exactly
    % honor the target output resolution. We adjust all four corners such
    % that the center of the image remains fixed in world coordinates.
    xNudge = (numCols*outputResolutionX-diff(XWorldLimitsOut))/2;
    yNudge = (numRows*outputResolutionY-diff(YWorldLimitsOut))/2;
    zNudge = (numPlanes*outputResolutionZ-diff(ZWorldLimitsOut))/2;

    XWorldLimitsOut = XWorldLimitsOut + [-xNudge xNudge];
    YWorldLimitsOut = YWorldLimitsOut + [-yNudge yNudge];
    ZWorldLimitsOut = ZWorldLimitsOut + [-zNudge zNudge];
    
    % Construct output referencing object with desired outputImageSize and
    % world limits.
    outputImageSize = [numRows numCols numPlanes];
    R_out = imref3d(outputImageSize,XWorldLimitsOut,YWorldLimitsOut,ZWorldLimitsOut);

end



end

