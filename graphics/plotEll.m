function h = plotEll(ell, varargin)
%PLOTELL Plot an ellipse.
% Usage:
%   plotEll(ell)
%   h = plotEll(ell)
%   plotEll(ell, ...) % args for plot()
% 
% Args:
%   ell: N x 5 or cell of 1 x 5
% 
% See also: drawEllipse

if iscell(ell); ell = vertcat(ell{:}); end
assert(size(ell,2) == 5)

% Angular positions of vertices
t = linspace(0, 360, 145);

% Get all the points
pts = cell(size(ell,1),1);
for i = 1:size(ell,1)
    pts{i} = getEllipsePoints(ell(i,:), t);
    ori_line = [ell(i,1:2); getEllipsePoints(ell(i,:), 0)];
    pts{i} = [pts{i}; NaN(1,2); ori_line; NaN(1,2)];
end
pts = vertcat(pts{:});

h = plot(pts(:,1),pts(:,2),varargin{:});
if nargout < 1; clear h; end

end
