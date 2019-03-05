function [peaks,vals] = impeaksnms(I, minThresh, sigma, conn)
%IMPEAKSNMS Finds the regional peaks in an image after thresholding.
% Usage:
%   [peaks,vals] = impeaksnms(I, minThresh, sigma, conn)
% 
% Args:
%   I: 2-D image
%   minThresh: minimum threshold (default = 0)
%   sigma: Gaussian smoothing kernel (default = 0)
%   conn: regional max connectivity - {4,8}-connected (default = 8)
%
% Returns:
%   peaks: N x 2 set of [x,y] coordinates
%   vals: N x 1 vector of the values at the peaks
% 
% See also: imregionalmax

if nargin < 2 || isempty(minThresh); minThresh = 0; end
if nargin < 3 || isempty(sigma); sigma = 0; end
if nargin < 4 || isempty(conn); conn = 4; end

if sigma > 0; I = imgaussfilt(I,sigma); end
isLowVal = I < minThresh;
peaks = []; vals = [];
if sum(~isLowVal(:)) == 0; return; end
I(isLowVal) = 0;

BW = imregionalmax(I,conn);
[r,c] = find(BW);
peaks = [c r];

if nargout > 1
    vals = I(BW);
end

end
