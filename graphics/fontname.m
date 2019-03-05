function fontname(name, h)
%FONTNAME Sets the fontname across a graphics object.
% Usage:
%   fontsize(size) % default: gcf
%   fontsize(size, fig)
%   fontsize(size, ax)
% 
% See also: fontsize
if nargin < 2; h = gcf; end

set(findobj(h,'-property','FontSize'),'FontName',name)

end
