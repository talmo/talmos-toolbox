function Q = unwrapd(P, cutoff, dim)
%UNWRAPD Unwraps the phase angle in degrees.
% Usage:
%   Q = unwrapd(P)
%   Q = unwrapd(P, cutoff)
%   unwrapd(P, cutoff, dim)
% 
% Args:
%   P: angles in degrees
%   cutoff: absolute threshold for wrapping (default: 180)
%   dim: dimension of P to work across (default: longest)
% 
% Returns:
%   Q: unwrapped P in degrees
%
% See also: unwrap, rad2deg, deg2rad

if nargin < 2 || isempty(cutoff); cutoff = 180; end
if nargin < 3; dim = argmax(size(P)); end

Q = rad2deg(unwrap(deg2rad(P),deg2rad(cutoff),dim));


end
