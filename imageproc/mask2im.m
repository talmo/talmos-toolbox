function I = mask2im(mask, vals)
%MASK2IM Creates an image of the size of the mask by inserting the specified values.
% Usage:
%   I = mask2im(mask, vals)
%
% See also: mask2pts

I = zeros(size(mask),'like',vals);

if isequal(size(vals), size(mask))
    I(mask) = vals(mask);
else
    I(mask) = vals;
end
end

