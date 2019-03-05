function C = vcat(varargin)
%VCAT Alias for vertcat.
% Usage:
%   C = vcat(X1, X2, ...)
% 
% See also: vertcat

isVec = cellfun(@isvector, varargin);
varargin(isVec) = cf(@vert, varargin(isVec));
C = vertcat(varargin{:});

end

