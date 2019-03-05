function TF = iscolormap(cmap)
%ISCOLORMAP Returns true if the specified string or matrix is a valid colormap.
% Usage:
%   TF = iscolormap(cmap)
%
% Returns:
%   TF: true if cmap is a valid colormap or an Mx3 matrix in the range [0,1]
%
% See also: colormap, colormaps

TF = false;
if ischar(cmap)
    TF = any(strcmpi(cmap, colormaps));
elseif isnumeric(cmap) && ismatrix(cmap)
    TF = size(cmap,2) == 3 & all(inrange(cmap(:), [0 1]));
end

end

