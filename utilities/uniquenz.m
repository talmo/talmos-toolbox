function [C, ia, ic] = uniquenz(A, varargin)
%UNIQUENZ Returns non-zero unique elements of an array.
% Usage:
%   C = uniquenz(X)
%   C = uniquenz(X, ...) % same params as unique
%   [C, ia, ic] = uniquenz(_)
% 
% Note: convenience for unique but excluding zeros
% 
% See also: unique

[C, ia, ic] = unique(A(A~=0),varargin{:});


end
