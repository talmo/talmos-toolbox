function seg = ccrefseg(L, ref, useGeodesic)
%CCREFSEG Description
% Usage:
%   seg = ccrefseg(L, ref, useGeodesic)
% 
% Args:
%   L: mask or labels to segment
%   ref: labels array with reference labels from bwlabel or another stack
%        of masks
%   useGeodesic: if true, use bwdistgeodesic instead of bwdist
%                (default = false)
% 
% Returns:
%   seg: array with labels from ref
% 
% See also: bwrefseg, bwdist, bwdistgeodesic

if nargin < 3; useGeodesic = false; end

if ismatrix(L) && islogical(L); L = bwlabel(L); end
if ismatrix(ref) && islogical(ref); ref = bwlabel(ref); end

if ismatrix(L); L = label2bw(L); end
if ismatrix(ref); ref = label2bw(ref); end

D = zeros(size(ref));
for k = 1:size(ref,4)
    if useGeodesic
        D(:,:,:,k) = bwdistgeodesic(ref(:,:,:,k));
    else
        D(:,:,:,k) = bwdist(ref(:,:,:,k));
    end
end

seg = zeros(size(L,1),size(L,2),'uint8');
for k = 1:size(L,4)
    Dk = D .* L(:,:,:,k);
    Dk_mu = mean(reshape(Dk,[],size(Dk,4)));
    seg(L(:,:,:,k)) = argmin(Dk_mu);
end

end
