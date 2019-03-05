function RGB = gray2rgb(G, cmap, scale)
%GRAY2RGB Converts a greyscale image to RGB.
% Usage:
%   RGB = gray2rgb(G)
%   RGB = gray2rgb(G, cmap) % specify a colormap to map the image to
%   RGB = gray2rgb(G, []) % keeps the colormap as the gray intensities
%   RGB = gray2rgb(G, cmap, false) % won't scale the image's colormap
%
% Note: When the image is scaled, the output looks the same as imagesc.
%
% See also: gray2ind, ind2rgb, colormap, imagesc

if nargin < 2
    cmap = parula(64);
end
if nargin < 3
    scale = true;
end

if scale
    G = G - min(G(:));
    G = G ./ max(G(:));
end

[G, map] = gray2ind(G);
if isempty(cmap)
    cmap = map;
end

RGB = ind2rgb(G, cmap);

end

