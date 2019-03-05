function [Ld, Lbnds] = watershed_seg(dens)
%WATERSHED_SEG Utility function for segmenting a 2d histogram via the watershed transform.
% Usage:
%   [Ld, Lbnds] = watershed_seg(dens)
% 
% Args:
%   dens: 2d density
%
% Returns:
%   Ld: dilated state map (no zeros at the boundaries)
%   Lbnds: binary mask of the state boundaries
% 
% See also: watershed, getDensity, ksdens

L = watershed(-dens);
BW = dens > min(dens(:));
L2 = L .* uint8(BW);

Lin = ~bwperim(L2) .* BW .* ~L2;
Lbnds = bwperim(BW) | Lin;

N = uniquenz(L2);
Ld = zeros(size(L2),'uint8');
for i = 1:numel(N)
    Ld = max(Ld,uint8(bwmorph(L2==N(i),'dilate',1)).*N(i));
end

end
