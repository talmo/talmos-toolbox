function varargout = get_last_plot_color(color_format)
%GET_LAST_PLOT_COLOR Returns the last color that the plot function used or NaN if no objects have been plotted yet.
% Usage:
%   get_last_plot_color()
%   color = get_last_plot_color()
%   color = get_last_plot_color(color_format)
% 
% Set the color_format to 'rgb', 'long_name', or 'short_name' to return the
%   color in a different format. Defaults to long_name if there are 0 
%   output arguments, otherwise RGB.
%
% See also: get_next_plot_color, cycle_plot_colors, fixed_colors

% Parse inputs
if nargin < 1
    if nargout == 0; color_format = 'long_name'; else color_format = 'rgb'; end
else
    color_format = validatestring(color_format, {'rgb', 'long_name', 'short_name'});
end

if ~isempty(get(0, 'CurrentFigure')) && ~isempty(get(gcf, 'CurrentAxes')) && ~isempty(get(gca, 'Children'))
    % Store current hold state
    hold_state = get_hold_state();
    hold all

    % Get the number of plot colors
    num_plot_colors = size(get(gca, 'ColorOrder'), 1);

    % Plot dummy points
    h = plot(NaN(2, num_plot_colors));

    % Get color from handle of last object plotted
    rgb_color = get(h(end), 'Color');

    % Remove dummy points from plot
    delete(h);

    % Reset to previous hold state
    hold(hold_state);
else
    rgb_color = NaN;
end

% Convert detected color to specified format
switch color_format
    case 'rgb'
        color = rgb_color;
    case 'long_name'
        color = rgb2name(rgb_color, true);
    case 'short_name'
        color = rgb2name(rgb_color, false);
end

% Output
if nargout == 0
    if ~ischar(color) || isempty(color)
        color = mat2str(rgb_color);
    end
    msg = sprintf('Last plot color: %s', color);
    
    if ~isnan(rgb_color)
        color_idx = find(ismember(get(gca, 'ColorOrder'), rgb_color, 'rows'));
        msg = sprintf('%s (%d/%d)', msg, color_idx, num_plot_colors);
    end
    fprintf('%s\n', msg);
else
    varargout = {color};
end


end

