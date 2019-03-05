function linkax(option)
%LINKAX Links axes in the current figure.
% Usage:
%   linkax % xy
%   linkax x
%   linkax y
% 
% Args:
%   option: 'off', 'x', 'y' or 'xy' (default)
% 
% See also: linkaxes, linkprop

if nargin < 1; option = 'xy'; end

ax = gcas;

linkaxes(ax, option)


end
