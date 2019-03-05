function BW_k = bwseparate(BW, k)
%BWSEPARATE Separates a binary mask into >= k components via skeletonization and iterative thickening.
% Usage:
%   BW_k = bwseparate(BW)
%   BW_k = bwseparate(BW, k)
%
% Args:
%   BW: binary mask with < k connected components
%   k: number of connected components desired (default: countcc(BW) + 1)
%
% Returns:
%   BW_k: binary mask with at least k connected components
%
% See also: bwmorph, countcc

if nargin < 2; k = countcc(BW) + 1; end
BW0 = BW;

% Skeletonize until we have <k CCs after opening
while countcc(bwmorph(BW,'open')) < k
    BW = bwmorph(BW,'skel',1);
end

% Apply the morphological opening
BW = bwmorph(BW, 'open');

% Thicken until we cover all of the original mask, keeping Euler number
% constant so we don't remerge our CCs
overlap = sum(sum(BW0 & BW));
done = false;
while ~done
    BW = bwmorph(BW, 'thicken', 1);
    new_overlap = sum(sum(BW0 & BW));
    done = new_overlap == overlap;
    overlap = new_overlap;
end

% Apply to original (merged) mask
BW_k = BW0 & BW;

end

