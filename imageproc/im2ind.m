function [ind, vals, sz] = im2ind(I)
%IM2IND Compresses an image into index-value pairs.
% Usage:
%   [ind, vals, sz] = im2ind(I)
%   S = im2ind(I)
% 
% Args:
%   I: 2-d image
% 
% See also: ind2im

ind = uint32(find(I));
vals = I(ind);
sz = size(I);

if nargout < 2
    ind = varstruct(ind, vals, sz);
end

end
