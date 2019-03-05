function R = imref2dctr(imageSize)
%IMREF2DCTR Returns an imref2d object where the center is at (0,0).
% Usage:
%   R = imref2dctr(imageSize)
%   R = imref2dctr(I)
% 
% Args:
%   imageSize: size of image
%   I: image
% 
% See also: imref2d

% Image passed in instead of size
if numel(imageSize) > 2 && ismatrix(imageSize)
    imageSize = size(imageSize);
end

R = imref2d(imageSize,[-imageSize(2)/2, imageSize(2)/2], [-imageSize(1)/2, imageSize(1)/2]);

end
