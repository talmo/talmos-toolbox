function state = get_hold_state(ax)
%GET_HOLD_STATE Returns the state of hold as a string: 'on', 'off' or 'all'.
% Usage:
%   state = get_hold_state
%   state = get_hold_state(ax)
%
% Detects the 'all' state, unlike ishold(). Also does not create a new
% figure if one is not already open.
%
% Args:
%   ax optionally specifies the handle to the axes object to query. This
%   defaults to the current axes on the current figure.

if nargin < 1
    ax = gca2;
end

% Default
state = 'off';

% The axes does not exist
if isempty(ax) || ~ishghandle(ax)
    % The default value of 'NextPlot' for a new axes is 'replace', so the
    % hold state will be 'off'
    return
end

% Compare the figure and axes properties to determine state
fig = get(ax, 'Parent');
if strcmp(get(ax, 'NextPlot'), 'add') && strcmp(get(fig, 'NextPlot'), 'add')
    if getappdata(ax, 'PlotHoldStyle')
        state = 'all';
    else
        state = 'on';
    end
end

end

