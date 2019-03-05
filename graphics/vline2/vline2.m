function varargout = vline2(varargin)

% Add vertical lines to plot.
%
% Usage:
%       vline2(x, [linetype], [labels], [options])
%       vline2('clear')
%       vline2(h_axes, ...)
%       [h_line, h_text] = vline2(...)
%
%           x: vector of x positions at which to draw lines
%    linetype: string or cell array of strings in short format,
%              e.g. 'r--' (default).
%              Alternatively, use long format:
%              e.g. 'color', [1 0 0], 'marker', 'none', 'linestyle', '--'
%      labels: string or cell array of strings with label for each line
%     options
%            .rotate    - rotate labels by number of degrees.
%                         Default: 0
%            .vpos      - Where in the plot should labels be placed?
%                         Can be 'top', 'bottom', 'center'
%                         Default: 'top'
%            .halign    - Which side of line should label be on?
%                         Can be 'left', 'right', 'center'
%                         Default: 'left'
%            .staircase - Stagger labels vertically to improve legibility
%                         Default: true
%            .textcolor - Set color of all labels, e.g. 'k'
%                         Default: Color is same as vertical line
%      h_axes: vector of axes handles.  Default: current axes
%      h_line: vector of line handles (or cell array of vectors if multiple 
%              axes were specified, one cell per axes)
%      h_text: vector of handles to text labels (or cell array of vectors
%              if multiple axes were specified, one cell per axes)
%     'clear': vline2('clear') or vline2(h_axes, 'clear') deletes all the
%              vertical lines previously created by this function.
%
% Example:
%   figure
%   plot(rand(20,1), 'k')
%   opts.vpos = 'center';
%   opts.halign = 'left';
%   opts.staircase = true;
%   vline2([4 10 11], {'k--', 'b:', 'g'}, {'first', 'second', '3rd'}, opts)

% Written: August 2010, K. Stahl (stahlRMkarlRMgmailRMcom), Stanford University, Gravity Probe B
%
% Several improvements to original 'vline':
% - Vectorize plotting for speed
% - Allow axes handle(s) to be specified
% - Allow standard line properties, e.g. 'linewidth'
% - Rotate labels if requested
% - Identify lines with 'vline' tags
% - Remove existing vertical lines easily with 'clear'.


% Parse and verify inputs
[all_x_pos, all_axes, lineopts, all_labels, do_clear, opts] = parse_inputs(varargin{:});

num_axes = length(all_axes);
h_line = cell(num_axes,1);
h_text = cell(num_axes,1);

% Go through all axes specified and add vlines and labels
for i = 1:num_axes
    
    h_axes = all_axes(i);
    
    % Clear existing vertical lines, if requested
    if do_clear
        delete(findall(h_axes, 'tag', 'vline'))
        delete(findall(h_axes, 'tag', 'vline_text'))
        continue
    end
    
    axes_held = ishold(h_axes);
    hold(h_axes, 'on')

    ylim = get(h_axes, 'ylim');
    
    x = all_x_pos;
    labels = all_labels;
    
    % Don't plot any vlines that fall outside the x range of the axes
    xlim = get(h_axes, 'xlim');
    k = find(x < xlim(1) | x > xlim(2));
    x(k) = [];
    if ~isempty(labels)
        labels(k) = [];
    end
    
    if size(lineopts,1) > 1
        % If user provided a separate set of lineopts for each line, then each
        % line must be plotted separately, using it's own 'plot' command.
        num_x = length(x);
        h_line_tmp = zeros(num_x,1);
        for k = 1:num_x
            h_line_tmp(k) = plot(h_axes, [x(k), x(k)], [ylim(1), ylim(2)], lineopts{k,:});
        end
        h_line{i} = h_line_tmp;
    else
        % One set of lineopts for all lines, so plot all lines simultaneously,
        % using a single 'plot' command for maximum speed.
        X = [x(:)'; x(:)'];
        Y = repmat(ylim(:), 1, length(x));
        h_line{i} = plot(h_axes, X, Y, lineopts{:});
    end
    
    % Make sure the bounding box stays the same.  Sometimes drawing the
    % vline makes Matlab recalculate the axes bounds.
    set(h_axes, 'ylim', ylim)
    
    % Add tag to line so we can find it later.
    % Also, hide the line from 'findobj'.
    set(h_line{:}, 'tag', 'vline', 'handlevisibility', 'off')
    
    % Add labels
    h_text{i} = add_labels(h_axes, x, labels, h_line{i}, opts);
    
    if ~axes_held
        hold(h_axes, 'off')
    end
end

if num_axes == 1
    h_line = h_line{:};
    h_text = h_text{:};
end

if nargout
    varargout{1} = h_line;
    varargout{2} = h_text;
end


% =========================================================================
function h_text = add_labels(h_axes, x_pos, labels, h_line_this_axes, opts)


h_text = [];

if isempty(labels)
    return
end

axes(h_axes)

x_lim = get(h_axes, 'xlim');
y_lim = get(h_axes, 'ylim');
y_height = y_lim(2)-y_lim(1);
y_pos = y_lim(2);  % default y position is top of axes

num_labels = length(labels);
% h_text = zeros(num_labels,1);
h_text = gobjects(num_labels,1); % R2013a

% Create labels
for i = 1:num_labels
    h_text(i) = text(x_pos(i), y_pos, labels{i}, ...
        'tag', 'vline_text', ...
        'color', get(h_line_this_axes(i), 'color'), ...
        'handlevisibility', 'off');
end

% Set all labels to be a single color, if requested
if ~isempty(opts.textcolor)
    set(h_text, 'color', opts.textcolor)
end

% Rotate text, if requested
set(h_text, ...
    'rotation', opts.rotate, ...
    'horizontalAlignment', opts.halign)

% Add a little margin between label and line
x_margin = .001*(x_lim(2)-x_lim(1));
for i = 1:num_labels
    p = get(h_text(i), 'position');
    switch opts.halign
        case 'left', new_x = p(1) + x_margin;
        case 'right', new_x = p(1) - x_margin;
        otherwise, new_x = p(1);
    end
    set(h_text(i), 'position', [new_x, p(2:end)])
end

% Place text vertically within axes
vmargin = .05; % percent space to leave below/above axes y limits
switch opts.vpos
    case 'top', y_pos = (1-vmargin)*y_height + y_lim(1);
    case 'bottom', y_pos = (vmargin)*y_height + y_lim(1);
    case 'center', y_pos = .5*y_height + y_lim(1);
    otherwise
        error(sprintf('\nUnrecognized value for ''vpos''.  Can be ''top'', ''bottom'', or ''center''.'))
end

for i = 1:num_labels
    p = get(h_text(i), 'position');
    p(2) = y_pos;
    set(h_text(i), 'position', p)
end

% Fix vertical position so it cycles through a 'staircase' to make labels
% more legible
if opts.staircase == true
    
    percent_to_shift = .05;
    
    y_height_no_margins = (1-2*vmargin)*y_height;
    step_size = percent_to_shift*y_height_no_margins;
    num_steps = round(y_height_no_margins/step_size);
    
    switch opts.vpos
        case 'top'
            start_step = num_steps;
            step_dir = -1; % down
        case 'center'
            start_step = floor(num_steps/2);
            step_dir = -1; % down
        case 'bottom'
            start_step = 0;
            step_dir = 1; % up
        otherwise
            error(sprintf('\nUnrecognized value for ''vpos''.  Can be ''top'', ''bottom'', or ''center''.'))
    end
    
    for i = 1:num_labels
        current_step = mod(start_step + step_dir*(i-1),num_steps+1);
        new_y_pos = y_lim(1) + vmargin*y_height + step_size*current_step;
        p = get(h_text(i), 'position');
        set(h_text(i), 'position', [p(1), new_y_pos, p(3)])
    end
end


% =========================================================================
function out = get_default_lineopts_struct

out.color = 'r';
out.linestyle = '--';
out.linewidth = 0.5;
out.marker = 'none';
out.markersize = 6;
out.markeredgecolor = 'auto';
out.markerfacecolor = 'none';


% =========================================================================
function out = struct2fullcell(s)

% Convert structure(s) into full cell array with alternating
% fieldnames and values.
%
% Usage:
%     out = struct2fullcell(s)
%
% Example:
%     s.Color = [1 0 0];
%     s.LineStyle = '-';
%     s.LineWidth = 0.5;
%     s.Marker = 'none';
%     s.MarkerSize = 6;
%     s.MarkerEdgeColor = 'auto';
%     s.MarkerFaceColor = 'none';
%     out = struct2fullcell(s)
%
% Example:
%     % Multiple structures are converted into multiple rows
%     s2 = repmat(s,3,1)
%     out = struct2fullcell(s2)


s = s(:);
f = fieldnames(s);
c = struct2cell(s);

num_rows = size(s,1);
out = cell(num_rows,length(f)+length(c));
for i = 1:num_rows
    out(i,:) = reshape([f'; c(:,i)'], 1, []);
end


% =========================================================================
function out = have_valid_linetype(str)

out = parse_line_options(str);


% =========================================================================
function [is_valid_linetype, linestyle, linecolor, linemarker] = parse_line_options(str)

% Check strings or cell array of strings to make sure user passed in valid
% linetype string(s).  Also parses string of type 'r.-' into linestyle,
% linecolor, and marker.

if iscell(str)
    num_str = length(str);
    is_valid_linetype = zeros(num_str,1);
    linestyle = cell(num_str,1);
    linecolor = cell(num_str,1);
    linemarker = cell(num_str,1);
    for i = 1:num_str
        [is_valid_linetype(i), linestyle{i}, linecolor{i}, linemarker{i}] = parse_line_options(str{i});
    end
    return
end

is_valid_linetype = false;

% NB: Any of these values that remain empty will be set to defaults below
linestyle = [];
linecolor = [];
linemarker = [];

L = length(str);
if ischar(str) && L<=4  % max length string is 4, e.g. 'bo--'
    
    % onecharopts
    lcolor = {'b', 'g', 'r', 'c', 'm', 'y', 'k', 'w'};
    lmarker = {'.', 'o', 'x', '+', '*', 's', 'd', 'v', '^', '<', '>', 'p', 'h'};
    lstyle = {'-', ':'};
    
    % Parse twocharopts (linestyle only)
    twocharopts = {'-\.'; '--'};
    [a, b] = regexp(str, twocharopts);
    k = find(~cellfun('isempty', a));
    if length(k) > 1
        fprintf('Invalid line options (%s). Cannot match multiple two character options!\n', str)
        return
    end
    if ~isempty(k)
        linestyle = str(a{k}:b{k});
        str(a{k}:b{k}) = [];
        lstyle = [];
    end
    
    % Parse remaining onecharopts
    L = length(str);
    for i = 1:L
        if ismember(str(i), lcolor)
            linecolor = str(i);
            lcolor = [];
            char_is_ok = 1;
        elseif ismember(str(i), lmarker)
            linemarker = str(i);
            lmarker = [];
            char_is_ok = 1;
        elseif ismember(str(i), lstyle)
            linestyle = str(i);
            lstyle = [];
            char_is_ok = 1;
        else
            char_is_ok = 0;
        end
        
        if ~char_is_ok
            return
        end
    end
    
    is_valid_linetype = true;
end

% Note that 'plot' does not allow you to set 'color', 'linestyle', or
% 'marker' to empty values.  Replace any empty values with defaults.
if is_valid_linetype
    if isempty(linestyle), linestyle = '-'; end
    if isempty(linecolor), linecolor = 'b'; end
    if isempty(linemarker), linemarker = 'none'; end
end


% =========================================================================
function [all_x_pos, all_axes, lineopts, all_labels, do_clear, opts] = parse_inputs(varargin)

% Defaults
all_x_pos = [];
all_axes = gca;
lineopts_struct = get_default_lineopts_struct;
lineopts = struct2fullcell(lineopts_struct);
all_labels = '';
do_clear = false;
opts.rotate = 0;
opts.halign = 'left';
opts.vpos = 'top';
opts.staircase = true;
opts.textcolor = [];

% Check if first argument is axes handle(s)
first_ind = 1;
if all(ishandle(varargin{1}))
    if all(strcmp(get(varargin{1}, 'type'), 'axes'))
        all_axes = varargin{1};
        first_ind = 2;
    else
        % Do nothing - in the ambiguous case where a number is provided
        % that is a handle, but not an axes handle, e.g. a figure handle,
        % assume the user really meant for that to be x position.
        %
        % error(sprintf('\nIf handles are provided, they must be axes handles.'))
    end
end

% Check if first argument is the string, 'clear'
if ischar(varargin{first_ind}) && strcmp(varargin{first_ind}, 'clear')
    do_clear = true;
    return
end

% Get x positions of vlines
if isnumeric(varargin{first_ind})
    all_x_pos = double(varargin{first_ind});
else
    error(sprintf('\nx positions of vertical lines must be numeric'))
end

% --- Go through any other arguments ---

% Get linetype
ind = first_ind+1;
if ind <= nargin
    if isempty(varargin{ind})
        % Do nothing, just keep default
    else
        linetype = varargin{ind};
        valid_options = fieldnames(lineopts_struct);
        if ischar(linetype)
            % linetype is a short format string, e.g. 'r:', or a set of
            % long format string/value pairs, e.g. 'color', [1 0 0], ...
            [is_valid_linetype, linestyle, color, marker] = parse_line_options(linetype);
            if is_valid_linetype
                % Short format
                lineopts_struct.linestyle = linestyle;
                lineopts_struct.color = color;
                lineopts_struct.marker = marker;
            else
                % Long format
                num2skip = 0;
                for i = ind:nargin
                    if num2skip > 0
                        num2skip = num2skip - 1;
                        continue
                    end
                    if ischar(varargin{i}) && ismember(varargin{i}, valid_options)
                        lineopts_struct.(varargin{i}) = varargin{i+1};
                        num2skip = 1;
                        ind = i+1;
                    else
                        break
                    end
                end
            end
        else
            % linetype is a cell array (possibly consisting of nothing but
            % strings in short format, e.g. {'r--', 'b:'}, or possibly
            % consisting of long format elements, e.g. 'color', [1 .5 1],
            % 'linestyle', '--'; 'color', 'b', 'linestyle', ':'; ...).  In 
            % the latter case, each row (shown separated by semi-colon)
            % corresponds to one line.
            num_lines = length(all_x_pos);
            lineopts_struct = repmat(lineopts_struct, num_lines, 1);
            if all(have_valid_linetype(linetype))
                % Short format
                if length(linetype) ~= num_lines
                    error(sprintf('\nIf a cell array of linetypes is given (e.g. {''r--'', ''k:''}), then it must\nhave the same number of elements as there are x positions.'))
                end
                for i = 1:num_lines
                    [is_valid_linetype, linestyle, color, marker] = parse_line_options(linetype{i});
                    lineopts_struct(i).linestyle = linestyle;
                    lineopts_struct(i).color = color;
                    lineopts_struct(i).marker = marker;
                end
            else
                % Long format
                if size(linetype,1) ~= num_lines
                    error(sprintf('\nIf a cell array of linetypes is given (e.g. {''color'', [1 0 0]; ''color'', [.5 .5 .5]}), then it must\nhave the same number of rows as there are x positions.'))
                end
                num_cols = size(linetype,2);
                for i = 1:num_lines
                    num2skip = 0;
                    for k = 1:num_cols
                        if num2skip > 0
                            num2skip = num2skip - 1;
                            continue
                        end
                        if ismember(linetype{i,k}, valid_options)
                            lineopts_struct(i).(linetype{i,k}) = linetype{i,k+1};
                            num2skip = 1;
                        else
                            error('Invalid line option')
                        end
                    end
                end
            end
        end
    end
end
lineopts = struct2fullcell(lineopts_struct);

% Get labels
ind = ind+1;
if ind <= nargin
    if isempty(varargin{ind})
        % Do nothing, just keep default
    else
        all_labels = varargin{ind};
        if iscell(all_labels)
            if length(all_labels) ~= length(all_x_pos)
                error(sprintf('\nIf a cell array is provided for labels, then it must\nhave the same number of elements as there are x positions.'))
            end
            if ~iscellstr(all_labels)
                error(sprintf('\nLabels must be a cell array of strings'))
            end
        elseif ischar(all_labels)
            % Make a cell array of the same string, repeated for each line
            all_labels = repmat({all_labels}, length(all_x_pos), 1);
        else
            error(sprintf('\nLabels must be a string or cell array of strings'))
        end
    end
end

% Get options
valid_options = {'rotate', 'vpos', 'halign', 'staircase', 'textcolor'};
ind = ind+1;
if ind <= nargin
    if isstruct(varargin{ind})
        f = fieldnames(varargin{ind});
        s = setdiff(f, valid_options);
        if ~isempty(s)
            error(sprintf('\n''%s'' is not a valid option field', s{1}))
        end
        for i = 1:length(f)
            switch f{i}
                case 'rotate'
                    if isnumeric(varargin{ind}.(f{i}))
                        opts.(f{i}) = varargin{ind}.(f{i});
                    else
                        error('Value for ''rotate'' option must be numeric')
                    end
                case 'vpos'
                    if any(strcmp(varargin{ind}.(f{i}), {'top', 'bottom', 'center'}))
                        opts.(f{i}) = varargin{ind}.(f{i});
                    else
                        error('Value for ''vpos'' option must be ''top'', ''bottom'', or ''center''')
                    end
                case 'halign'
                    if any(strcmp(varargin{ind}.(f{i}), {'left', 'right', 'center'}))
                        opts.(f{i}) = varargin{ind}.(f{i});
                    else
                        error('Value for ''halign'' option must be ''left'', ''right'', or ''center''')
                    end
                case 'staircase'
                    if islogical(varargin{ind}.(f{i})) || (isnumeric(varargin{ind}.(f{i})) && ismember(varargin{ind}.(f{i}), [0 1]))
                        opts.(f{i}) = varargin{ind}.(f{i});
                    else
                        error('Value for ''staircase'' must be a boolean')
                    end
                case 'textcolor'
                    [is_valid_linetype, junk, linecolor] = parse_line_options(varargin{ind}.(f{i}));
                    if is_valid_linetype || isempty(linecolor)
                        opts.(f{i}) = linecolor;
                    else
                        error('Invalid option for ''textcolor''')
                    end
                otherwise
                    opts.(f{i}) = varargin{ind}.(f{i});
            end
        end
    else
        error(sprintf('\nOptions must come in a struct'))
    end
end
