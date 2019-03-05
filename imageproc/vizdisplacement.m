function vizdisplacement(D, scale, step, varargin)
%VIZDISPLACEMENT Plots a quiver plot representing the displacement field.
% Usage:
%   vizdisplacement(D)
%   vizdisplacement(D, scale) % step = scale
%   vizdisplacement(D, scale, step)
%   vizdisplacement(_, 'Name', Value) % quiver args
%
% See also: quiver

if nargin < 2; scale = 1; end
if nargin < 3; step = scale; end

[XX, YY] = meshgrid(1:step:size(D,2), 1:step:size(D,1));
U = D(1:step:end,1:step:end,1);
V = D(1:step:end,1:step:end,2);

quiver(XX, YY, U, V, scale, varargin{:})

end

