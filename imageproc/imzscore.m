function Iz = imzscore(I, zlims, fgOnly)
%IMZSCORE Normalizes an image by z-scoring the pixels.
% Usage:
%   Iz = imzscore(I)
%   Iz = imzscore(I, zlims)
%   Iz = imzscore(I, zlims, fgOnly)
% 
% Args:
%   I: 2-d image
%   zlims: rescale to limits if non-empty (default: [])
%          must have 2 elements specifying min and max z-score
%   fgOnly: only consider foreground (non-zero) pixels (default: true)
% 
% See also: zscore

if nargin < 2; zlims = []; end
if nargin < 3; fgOnly = true; end

BW = true(size(I));
if fgOnly
    BW = I > 0;
end

vals = zscore(I(BW));

if ~isempty(zlims)
    vals = min(vals, max(zlims));
    vals = max(vals, min(zlims));
    vals = (vals - min(zlims)) ./ (max(zlims) - min(zlims));
end

Iz = I;
Iz(BW) = vals;

end
