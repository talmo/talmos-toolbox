function ax = gcas(fig)
%GCAS Returns the handles to all of the axes on a figure.
% Usage:
%   ax = gcas
%   ax = gcas(fig)
% 
% See also: gca, gca2

if nargin < 1; fig = gcf; end

ax = findobj(fig,'Type','Axes');

end
