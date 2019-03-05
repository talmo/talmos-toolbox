function [seg, D, Didx] = bwrefseg(BW, ref, useGeodesic)
%BWREFSEG Segments a mask using a reference labels array.
% Usage:
%   seg = bwrefseg(BW, ref)
%   seg = bwrefseg(BW, ref, true) % use geodesic distance
%   [seg, D, Didx] = bwrefseg(_)
% 
% Args:
%   BW: mask to segment
%   ref: labels array with reference labels from bwlabel or another stack
%        of masks
%   useGeodesic: if true, use bwdistgeodesic instead of bwdist
%                (default = false)
% 
% Returns:
%   seg: array with labels from ref where BW is true
%   D: distance matrix stack (size(D,4) == number of labels)
%   Didx: array of the same size as BW with labels for every pixel
% 
% See also: ccrefseg, bwdist, bwdistgeodesic

if nargin < 3; useGeodesic = false; end

% Get reference label masks separated into a stack
if iscell(ref)
    ref = cellcat(ref,4);
end
if ~islogical(ref)
    ref = label2bw(ref);
end

% Compute distance transform from each reference mask
D = zeros(size(ref),'single');
for i = 1:size(D,4)
    if useGeodesic
        D(:,:,:,i) = bwdistgeodesic(BW, ref(:,:,:,i));
    else
        D(:,:,:,i) = bwdist(ref(:,:,:,i));
    end
end

% Find closest label to each pixel
Didx = uint8(argmin(D,4));

% Apply labels to original mask
seg = mask2im(BW, Didx(BW));

end
