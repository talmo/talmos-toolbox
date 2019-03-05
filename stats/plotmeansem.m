function [hl,hp] = plotmeansem(t, X, varargin)
%PLOTMEANSEM Plot mean and standard error of the mean.
% Usage:
%   plotmeansem(X)
%   plotmeansem(t, X)
%   plotmeansem(_, ...) % boundedline parameters
%
% Args:
%   t: 1 x n timepoints
%   X: m series x n timepoints
%
% Example:
%   plotmeansem(1:10,rand(100,10),'r-','alpha')
% 
% See also: plotmeanstd, plot95perc, boundedline

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


[hl, hp] = boundedline(t, nanmean(X), nanstd(X) ./ sqrt(size(X,1)), varargin{:});

hl.UserData.t = t;
hl.UserData.X = X;

if nargout < 1; clear hl hp; end

end
