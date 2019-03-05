function cpts = convhullpts(pts, varargin)
%CONVHULLPTS Wrapper for convhull that returns the computed points.
% Usage:
%   cpts = conhullpts(pts)
%   cpts = conhullpts(pts, 'simplify', true)
%
% See also: convhull

k = convhull(pts(:,1), pts(:,2), varargin{:});
cpts = pts(k,:);

end

