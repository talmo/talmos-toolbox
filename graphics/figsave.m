function figsave(path, h)
%FIGSAVE Saves a figure to PNG and SVG.
% Usage:
%   figsave(path)
%   figsave(path, h)
% 
% Args:
%   path: path to output without extension
%   h: graphics handle to save (default: gcf)
% 
% See also: print, export_fig

if nargin < 2 || isempty(h); h = gcf; end

print(h, [path '.png'], '-dpng', '-opengl', '-r300');
print(h, [path '.svg'], '-dsvg', '-painters');

end
