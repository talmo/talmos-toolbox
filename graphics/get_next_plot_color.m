function color = get_next_plot_color(ax, color_format)
%GET_NEXT_PLOT_COLOR Returns the next color that the plot function will use.
% Usage:
%   get_next_plot_color
%   color = get_next_plot_color
%   color = get_next_plot_color(ax, color_format)
% 
% Set the color_format to 'rgb', 'long_name', or 'short_name' to return the
%   color in a different format. Defaults to 'long_name' if there are no 
%   output arguments, otherwise RGB.
%
% Note:
%   If the hold state is 'on' or 'off', the ColorOrder is reset before
%   plotting so the first color is used again.
%
% See also: get_plot_color, get_last_plot_color, cycle_plot_colors

% Parse inputs
if nargin < 1
    ax = gca2;
end
if nargin < 2
    if nargout == 0; color_format = 'long_name'; else color_format = 'rgb'; end
end
color_format = validatestring(color_format, {'rgb', 'long_name', 'short_name'});

% Default color order
color_order = get(0,'DefaultAxesColorOrder');
if ~isempty(ax) && ishghandle(ax)
    % Get the color order in the current axes if it exists
    color_order = get(ax, 'ColorOrder');
end
num_colors = size(color_order, 1);

% Next color depends on the hold state
switch get_hold_state(ax)
    case {'on', 'off'}
        % Color order pointer will be reset on the next plot
        rgb_color = color_order(1, :);
        
    case 'all'
        % Plot dummy points to go through full cycle of color order
        h = plot(NaN(2, num_colors));
        
        % Get color from handle of first object
        rgb_color = get(h(1), 'Color');
        
        % Remove dummy points from plot
        delete(h);
end

% Convert color to specified format
switch color_format
    case 'rgb'
        color = rgb_color;
    case 'long_name'
        color = rgb2name(rgb_color, true);
    case 'short_name'
        color = rgb2name(rgb_color, false);
end

% Console output
if nargout == 0
    if ~ischar(color) || isempty(color)
        color = mat2str(rgb_color);
    end
    color_idx = find(ismember(color_order, rgb_color, 'rows'));
    fprintf('Next plot color: %s (%d/%d)\n', color, color_idx, num_colors);
    
    % Don't return variable
    clear color
end

end

