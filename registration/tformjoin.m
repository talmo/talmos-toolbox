function Tout = tformjoin(T1, T2, varargin)
%TFORMJOIN Joins a series of affine2d transforms in order.
% Usage:
%   Tout = tformjoin(T1, T2, ...)
%   Tout = tformjoin(C)
%
% Args:
%   T1, T2, ...: affine2d objects or 3x3 matrices
%   C: cell array of affine2d objects or 3x3 matrices
%
% Returns:
%   Tout: combined affine2d object
%
% See also: affine2d

if nargin < 2; T2 = {eye(3)}; end

if ~iscell(T1); T1 = {T1}; end
if ~iscell(T2); T2 = {T2}; end

tforms = [T1, T2, varargin];

Tout = eye(3);
for i = 1:numel(tforms)
    if isa(tforms{i},'affine2d')
        tforms{i} = tforms{i}.T;
    end
    if isnumeric(tforms{i}) && isequal(size(tforms{i}), [3,3])
        Tout = Tout * tforms{i};
    else
        error('Transforms must be affine2d or 3x3 matrices.')
    end
end
Tout = affine2d(Tout);
end
