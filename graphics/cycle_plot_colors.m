function cycle_plot_colors(offset)
%CYCLE_PLOT_COLORS Cycles the plot colors to the next plot color.
% Usage:
%   cycle_plot_colors()
%   cycle_plot_colors(offset)
%
% offset can be any integer (default = 1)
%
% See also: get_next_plot_color, get_last_plot_color, get_plot_color

if nargin < 1
    offset = 1;
end

% Store current hold state
hold_state = get_hold_state();
hold all

% Get the number of plot colors
num_plot_colors = size(get(gca, 'ColorOrder'), 1);

% Figure out how many dummy points to plot
N = mod(offset, num_plot_colors);

% Plot dummy points
h = plot(NaN(2, N));

% Remove dummy points from plot
delete(h);

% Reset to previous hold state
hold(hold_state);

end

