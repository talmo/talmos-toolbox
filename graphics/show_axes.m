function show_axes()
%SHOW_AXES Plots a line through the x and y axes.

hold_state = get_hold_state();

hold on
plot([0 0], ylim, '-k');  %x-axis
plot(xlim, [0 0], '-k');  %y-axis

hold(hold_state)

end

