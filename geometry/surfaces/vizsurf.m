function h = vizsurf(node, elem, facealpha, edgealpha, varargin)
%VIZSURF Description
% Usage:
%   vizsurf(node, elem, facealpha)
% 
% Args:
%   node: 
%   elem: 
%   facealpha: 
% 
% See also: 

if isstruct(node)
    if nargin > 1 && (nargin < 3 || isempty(facealpha))
        facealpha = elem;
    end
    elem = node.elem;
    node = node.node;
end

if nargin < 3 || isempty(facealpha); facealpha = 0.9; end
if nargin < 4 || isempty(edgealpha); edgealpha = 0; end

if size(elem,2) < 4
    elem(:,end+1) = 1;
end

% figure
% plottetra(node,elem,'facealpha',facealpha,'linestyle','-')
h = plotmesh(node, elem, 'facealpha',facealpha,'linestyle','-','edgealpha',edgealpha, varargin{:});
axis equal
graygrid
camlight
lighting gouraud
material metal

if nargout < 1; clear h; end

end
