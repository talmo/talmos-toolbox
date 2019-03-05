function [hl,hp] = plotmeanci(t, X, nboot, varargin)
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

% TODO: fix all input paths
if nargin == 1
    X = t;
    clear t
elseif nargin > 1 && ischar(X)
    varargin = [{X} varargin];
    X = t;
    clear t
% elseif nargin > 1 && isscalar(X) && isnumeric(X)
%     X = t;
%     clear t
elseif nargin > 2 && ischar(nboot)
    varargin = [{X} varargin];
end

if ~exist('t', 'var')
    t = 1:size(X,2);
end

t = t(:)';
if size(X,2) ~= numel(t)
    X = X';
end

% mu = nanmean(p1_all_ctr_maxWingAngM);
% ci = bootci(300,{@nanmean,p1_all_ctr_maxWingAngM},'Options',statset('UseParallel',true));
% ci = abs(ci - mu);

[hl, hp] = boundedline(t, nanmean(X), nanstd(X), varargin{:});
% boundedline(ctr_ts,mu,ci','alpha','cmap',col_P1)

if nargout < 1; clear hl hp; end

end
