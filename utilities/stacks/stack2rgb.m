function S = stack2rgb(S, cmap, clims)
%STACK2RGB Scales a stack into a colormap.
% Usage:
%   S = stack2rgb(S)
%   S = stack2rgb(S, cmap)
%   S = stack2rgb(S, cmap, clims)
%
% See also: real2rgb

if nargin < 2 || isempty(cmap); cmap = 'parula'; end
if nargin < 3 || isempty(clims); clims = [min(S(:)) max(S(:))]; end

if isempty(gcp('nocreate'))
    S = stackfun(@(x)real2rgb(x,cmap,clims),S);
else
    S = spf(@(x)real2rgb(x,cmap,clims),S);
end

end

