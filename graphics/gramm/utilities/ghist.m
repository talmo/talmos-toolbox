function varargout = ghist(X,color)
%GHIST Pretty histogram/PDF estimate using gramm!
% Usage:
%   ghist(X)
%   ghist(X, color)
%   g = ghist(X) % returns gramm object
% 
% Args:
%   X: data matrix supported by 'x' parameter of gramm
%   color: grouping/coloring vector of same size as X
%
% Note: this is a wrapper for gramm.stat_bin() and stat_density()
% 
% See also: gramm

if nargin < 2; color = []; end

if isempty(color)
    g = gramm('x',X);
else
    g = gramm('x',X,'color',color);
end

g.stat_density();
g.stat_bin('normalization','pdf','geom','overlaid_bar');

g.axe_property('Box','off','Color',[1 1 1].*234/255,...
    'XGrid','on','YGrid','on','GridColor',[1 1 1],'GridAlpha',1);
g.set_limit_extra([0.05 0.05],[0 0.05]);

g.draw();
set(gcf,'renderer','painters')

if nargout > 0; varargout = {g}; end
end
