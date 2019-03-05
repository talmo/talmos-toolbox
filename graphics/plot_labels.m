function h = plot_labels(L, color, alpha, ax)
%PLOT_LABELS Plots each unique label in L as a transparent patch object.
% Usage:
%   plot_labels(L)
%   plot_labels(L, color)
%   plot_labels(L, colors)
%   plot_labels(..., alpha, ax)
%   h = plot_labels(_)
%
% Args:
%   L: labels matrix
%   color: character or [r g b] matrix (default: plot color cycle)
%   colors: same as above but with as many rows as unique (non-zero)
%           values in L
%   alpha: patch transparency (default: 0.6)
%   ax: axes to plot on (default: gca)
%
% Returns:
%   h: handle to graphics
% 
% See also: draw_poly, bwboundarypts, bwboundarypts

if nargin < 4; ax = gca; end
if nargin < 2; color = []; end
if nargin < 3; alpha = 0.6; end

% Convert color character to RGB
if any(ischar(color(:)))
    color = af(@name2rgb, color);
    if any(areempty(color)); error('Invalid color character specified.'); end
    color = cellcat(color,1);
end

% Get non-zero groups into masks
% BW = label2bw(L);
% N = size(BW,4);
pts = bwboundarypts(L);
N = numel(pts);

if ~isempty(color)
    if size(color,1) == 1
        % Expand if specified single color
        color = repmat(color, N, 1);
    end
%     if size(color,2) == 1
%         % Default to color cycle
%         idx = ax.ColorOrderIndex + mod(color-1,size(ax.ColorOrder,1));
%         color = ax.ColorOrder(idx,:);
%     end
end

% Plot each group
h = gobjects(N,1);
for i = 1:N
    % Default to color cycle
    if isempty(color); color_i = nextColor(ax, true);
    else; color_i = color(i,:); end
    
%     h(i) = alphamask(BW(:,:,:,i), color_i, alpha);
    h(i) = patch('XData', pts{i}(:,1), 'YData', pts{i}(:,2), ...
        'FaceColor', color_i, 'FaceAlpha', alpha, ...
        'EdgeColor', color_i);
end

if nargout < 1; clear h; end
end
