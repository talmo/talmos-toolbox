function h = bwshowpair(I, BW, varargin)
%BWSHOWPAIR Shows an image with overlayed mask.
% Usage:
%   bwshowpair(I, BW)
%   bwshowpair(I, BW, ...)
%   h = bwshowpair(_) % imoverlay args
%
% See also: imoverlay

img = imoverlay(I, BW, varargin{:});

h = imagesc(img);
axis image


if nargout < 1
    clear h
end

end

