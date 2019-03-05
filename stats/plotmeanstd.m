function [hl,hp] = plotmeanstd(t, X, varargin)
%PLOTMEANSTD Plot mean and standard deviation.
% Usage:
%   plotmeanstd(X)
%   plotmeanstd(t, X)
%   plotmeanstd(_, ...) % boundedline parameters
%
% Args:
%   t: 1 x n timepoints
%   X: m series x n timepoints
%
% Example:
%   plotmeanstd(1:10,rand(100,10),'r-','alpha')
% 
% See also: plot95perc, boundedline

if nargin == 1
    X = t;
    clear t
elseif nargin > 1 && ischar(X)
    varargin = [{X} varargin];
    X = t;
    clear t
end

if ~exist('t', 'var')
    t = 1:size(X,2);
end

t = t(:)';
if size(X,2) ~= numel(t)
    X = X';
end


[hl, hp] = boundedline(t, nanmean(X), nanstd(X), varargin{:});

hl.UserData.t = t;
hl.UserData.X = X;

if nargout < 1; clear hl hp; end

end
