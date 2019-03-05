function h = vline(x, varargin)
%VLINE Easy plotting of a vertical line.
% Usage:
%   vline
%   vline(x)
%   vline(ax, _)
%   vline(_, ...) % plot args (e.g., linespec)
%   h = vline(_)
% 
% Args:
%   x: x-value
% 
% See also: hline

if nargin < 1; x = []; end
ax = [];
if isax(x)
    ax = x;
    x = [];
    if nargin > 1
        arg1 = varargin{1};
        if isnumeric(arg1)
            x = arg1;
            varargin(1) = [];
        end
    end
end

if isempty(ax)
    ax = gca;
end

if isempty(x)
    x = mean(xlim(ax));
end

state = ax.NextPlot;
ax.NextPlot = 'add';

Y = ylim(ax) .* ones(numel(x),1);
X = [1 1] .* x(:);
if isvector(x)
    X = [X NaN(size(X,1),1)]';
    Y = [Y NaN(size(Y,1),1)]';
end

h = plot(ax,X(:),Y(:), varargin{:});

ax.NextPlot = state;

if nargout < 1; clear h; end

end
