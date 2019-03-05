function pts = cleanpeaks(C, K, sigma)
%CLEANPEAKS Finds K peaks in each channel of C using the CLEAN approach.
% Usage:
%   pts = cleanpeaks(C, k, sigma)
% 
% Args:
%   C: 4-d tensor of confidence maps (HxWxPxN)
%   K: number of components per channel
%   sigma: Gaussian kernel width (default: 5)
%
% Returns:
%   pts: Kx2xPxN
% 
% See also: confmaps2pts

if nargin < 3 || isempty(sigma); sigma = 5; end

% Pre-generate image grid
sz = [size(C,1), size(C,2)];
[XX,YY] = meshgrid(1:sz(2),1:sz(1));

% PDF generator
pdf = @(x,y)exp(-((XX-x).^2 + (YY-y).^2)./(2*sigma^2));

% Initialize and run through components/channels/time
pts = zeros(K,2,size(C,3),size(C,4));
for k = 1:K
    for p = 1:size(C,3)
        for t = 1:size(C,4)
            c = C(:,:,p,t);
            [ymax, xmax] = ind2sub(sz, argmax(c(:)));
            pts(k,:,p,t) = [xmax ymax];
            
            C(:,:,p,t) = c - pdf(xmax,ymax);
        end
    end
end

end
