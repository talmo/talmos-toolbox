function rect = imfind(I, varargin)
%IMFIND Finds the nonzero pixels in an image and returns their containing rectangle.
% Usage:
%   rect = imfind(I)
%   rect = imfind(I1, I2, ...)
%
% Example:
%   imshow(I), hold on, drawRect(imfind(I))
%
% See also: imcrop, boundingBox, boxToRect, drawRect

[y, x] = find(max(I,[],3) > 0);
bbox = boundingBox([x,y]);

if nargin > 1
    for i = 1:numel(varargin)
        [y, x] = find(max(varargin{i},[],3) > 0);
        bbox = mergeBoxes(bbox, boundingBox([x,y]));
    end
end

rect = boxToRect(bbox);
end

