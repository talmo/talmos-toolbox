function export2eps(filename, h)
%EXPORT2EPS Convenience wrapper to save eps figs with print/epsclean.
% Usage:
%   export2eps(filename)
%   export2eps(filename, h)
% 
% Args:
%   filename: path to save to (appends '.eps' if not included)
%   h: graphics handle to export (default: gcf)
% 
% Note: this maintains vector format for objects with transparency, unlike export_fig
% 
% See also: export_fig, print, epsclean

if nargin < 2; h = gcf; end

if ~endsWith(filename,'.eps'); filename = [filename '.eps']; end

print(h,'-depsc','-painters',filename);
% print(h,'-depsc',filename);
% epsclean(filename)

end
