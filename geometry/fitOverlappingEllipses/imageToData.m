function [xyData] = imageToData(img)

%converts an image (passed as matlab matrix of intensity values-integers) into an intensity-weighted (by
%duplicating the respective coordinates) list of xy coordinates

h = size(img,1);
w = size(img,2);
frsz = h*w;

l = sum(img(:));

img1D = zeros(frsz,5);
img1D(:,1) = reshape(img,frsz,1); % reshapes into columns; newindex = h*(x-1)+y

indList = [1:1:frsz]';

img1D(:,2) = ceil(indList./h); % x coordinates
img1D(:,3) = indList - h*(img1D(:,2) - 1);
img1D(img1D(:,1) == 0,:) = [];

newlen = size(img1D,1);

img1D(:,5) = cumsum(img1D(:,1));
img1D(2:newlen,4) = img1D(1:newlen-1,5) + 1;
img1D(1,4) = 1;

xyData = zeros(l,2);
for count = 1:newlen
    xyData(img1D(count,4):img1D(count,5),1) = img1D(count,2);
    xyData(img1D(count,4):img1D(count,5),2) = img1D(count,3);
end
