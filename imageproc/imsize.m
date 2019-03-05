function sz = imsize(imgPath)
%IMSIZE Returns the image dimensions in [numRows, numCols]
% Usage:
%   sz = imsize(imgPath)
% 
% Note:
%   This is equivalent to size(imread(imgPath)) but only for two dims.
%
% See also: imfinfo

info = imfinfo(imgPath);
sz = [info(1).Height, info(1).Width];

end

