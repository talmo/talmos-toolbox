function IM2 = erode(IM, n, shape)
%ERODE Convenience wrapper for imerode.
% Usage:
%   IM2 = erode(IM)
%   IM2 = erode(IM, n)
%   IM2 = erode(IM, n, shape)
% 
% Args:
%   IM: 2d image
%   n: size of structuring element (default = 1)
%   shape: shape of structuring element (default = 'disk')
%
% Returns:
%   IM2: resulting 2d image after erosion
% 
% See also: imerode, strel

if nargin < 2; n = 1; end
if nargin < 3; shape = 'disk'; end

IM2 = imerode(IM, strel(shape,n));

end
