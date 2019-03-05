function [point, val] = imargmax(I, coordinates)
%IMARGMAX Returns the coordinates of the peak in an image.
% Usage:
%   [point, val] = imargmax(I)
%   [point, val] = imargmax(I, 'ij')
% 
% Args:
%   I: 
%   coordinates: 
%
% Returns:
%   point: 
%   val:  
% 
% See also: argmax, max

if nargin < 2 || isempty(coordinates); coordinates = 'xy'; end

[val, ind] = max(I(:));
[i,j] = ind2sub(size(I),ind);

if strcmpi(coordinates,'xy')
    point = [j i];
elseif strcmpi(coordinates,'ij')
    point = [i j];
else
    error('Coordinates must be ''xy'' or ''ij''.')
end

end
