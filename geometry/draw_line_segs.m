function draw_line_segs(P, Q, show_intersect)
%DRAW_LINE_SEGS Draws the line segments P and Q and optionally their intersect.
% Usage:
%   draw_line_segs(P, Q)
%   draw_line_segs(P, Q, show_intersect)

if nargin < 3
    show_intersect = true;
end

% Plot the lines
plot(P(:, 1), P(:, 2), '-x', Q(:, 1), Q(:, 2), '-x')

if show_intersect
    % Save hold state
    hold_state = get_hold_state; 
    hold all
    
    % Find the intersect
    I = intersect_line_segs(P, Q);
    
    %
    plot(I(:, 1), I(:, 2), 'ro-')
    
    % Restore hold
    hold(hold_state);
end
end

