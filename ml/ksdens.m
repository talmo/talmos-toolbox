function [dens, pts, bandwidth] = ksdens(X, pts, bandwidth, varargin)
%KSDENS Kernel density estimation -- now more convenient!
% Usage:
%   dens = ksdens(X)
%   dens = ksdens(X, pts, bandwidth, ...)
%
% Args:
%   X: 1-d or 2-d matrix
%   pts: vector (1-d) or matrix (2-d) of points to evaluate at, or scalar
%        to specify number of points across each dimension (default: 120)
%   bandwidth: smoothing parameter (default: [] = auto)
%   
% Returns:
%   dens: computed density (PxP)
%   pts: point on which the function was evaluated (|PxP| x 1 or 2)
% 
% See also: ksdensity

if nargin < 2 || isempty(pts); pts = 120; end
if nargin < 3 || isempty(bandwidth); bandwidth = []; end

sz = [];
if isvector(X)
    if isscalar(pts)
        pts = linspace(min(X(:)),max(X(:)),pts);
    end
    sz = size(pts);
else
    if isscalar(pts)
        x = linspace(min(X(:,1)),max(X(:,1)),pts);
        y = linspace(min(X(:,2)),max(X(:,2)),pts);
        [xq,yq] = meshgrid(x,y);
        sz = size(xq);
        pts = [xq(:),yq(:)];
    end
    
    if isvector(pts)
        [xq,yq] = meshgrid(pts,pts);
        sz = size(xq);
        pts = [xq(:),yq(:)];
    end
    
    if isempty(sz)
        sz = [nunique(pts(:,2)),nunique(pts(:,1))];
    end
end

args = varargin;
if ~isempty(bandwidth); args = [{'Bandwidth',bandwidth},varargin]; end

[dens,~,bandwidth] = ksdensity(X,pts,args{:});

dens = reshape(dens,sz);

if nargout < 1
    if isvector(X)
        figclosekey
        plot(pts, dens)
        xlabel('X'), ylabel('PDF')
        clear dens pts bandwidth
    else
        imgsc(unique(pts(:,1)), unique(pts(:,2)), dens)
        axis xy
        xlabel('X_1'), ylabel('X_2')
        clear dens pts bandwidth
    end
end

end
