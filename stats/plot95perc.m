function [hl, hp] = plot95perc(t, X, varargin)
%PLOT95PERC Plot median and 95% percentiles.
% Usage:
%   plot95perc(X)
%   plot95perc(t, X)
%   plot95perc(_, ...) % boundedline parameters
%
% Args:
%   t: 1 x n timepoints
%   X: m series x n timepoints
%
% Example:
%   plot95perc(1:10,rand(100,10),'r-','alpha')
% 
% See also: plotmeanstd, boundedline

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

ymean = nanmedian(X, 1);
yci = prctile(X, [2.5 97.5]);
yci(1,:) = abs(yci(1,:) - ymean);
yci(2,:) = abs(yci(2,:) - ymean);

[hl, hp] = boundedline(t, ymean, yci', varargin{:});

if nargout < 1; clear hl hp; end

end
