function I = imerodedilate(I, n)
%IMERODEDILATE Applies erosion then dilation by n pixels.
% Usage:
%   I = imerodedilate(I) % n = 1
%   I = imerodedilate(I, n)
%
% Note: This function is basically equivalent to imopen, i.e.:
%     >> isequal(imopen(I, strel('square', n)), imerodedilate(I, n))
%     ans =
%          1
%
% See also: imopen, imerode, imdilate, strel

if nargin < 2
    n = 1;
end

SE = strel('square', n);
I = imdilate(imerode(I, SE), SE);

end

