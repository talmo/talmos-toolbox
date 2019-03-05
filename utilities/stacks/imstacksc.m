function [h_fig, h_img] = imstacksc(S, clims, cmap, callbacks, varargin)
%IMSTACKSC Scaled stack image viewer.
% Usage:
%   imstacksc(S) % parula or grey if it seems to be an intensity stack
%   imstacksc(S, cmap)
%   imstacksc(S, clims)
%   imstacksc(S, clims, cmap)
%   imstacksc(S, clims, cmap, callbacks)
%
% Args:
%   callbacks: function handle or cell array of function handles
%       Each will get called with the signature f(fig_handle, idx) after
%       each frame is drawn
%

% Validate stack
S = validate_stack(S);
numChannels = size(S,3);
numFrames = size(S,4);

% Empty if not specified
if nargin < 2; clims = []; end
if nargin < 3; cmap = []; end
if nargin < 4; callbacks = {}; end

% Parse positional parameters
pos_params = {clims, cmap, callbacks};
clims = []; cmap = []; callbacks = [];
p_last = [];
while ~isempty(pos_params)
    p = pos_params{1};
    if isnumeric(p) && numel(p) == 2 % color limits
        clims = p;
    elseif iscolormap(p) % colormap
        cmap = p;
    elseif iscell(p) && ~isempty(p) && all(cellfun(@(x)isa(x, 'function_handle'),p)) % callbacks
        callbacks = p;
    elseif isa(p, 'function_handle') % single callback
        callbacks = {p};
    else % name-value parameter
        if ischar(p) || ischar(p_last)
            varargin{end+1} = p;
            p_last = p;
        end
    end
    pos_params(1) = [];
end

% Positional defaults
if isempty(clims)
    clims = double(alims(S));
    if any(isinf(clims))
        clims = alims(S(~isinf(S)));
    end
    if clims(1) == clims(2)
        error('Image limits are the same.')
    end
end
if isempty(cmap)
    cmap = 'parula';
    if isinteger(S) || islogical(S)
        cmap = 'gray';
    end
end

% Parse additional parameters
defaults = struct();
defaults.stackName = inputname(1);
defaults.initialFrame = 1;
defaults.initialChannel = 1;
defaults.autoplay = false;
defaults.fps = 25;
defaults.stride = 1;
defaults.save = false;
defaults.saveTarget = 'ax'; % 'fig' or 'ax'
defaults.clear = true; % clear graphics objects on axes between frames
defaults.ticks = false;
defaults.colorbar = numChannels == 1;
defaults.tight = false;
defaults.autotile = false; % tiles channels
params = parse_params(varargin, defaults);

% Initialize graphics
fig = figure('KeyPressFcn', @KeyPressCB, ...
    'CloseRequestFcn', @OnClose, ...
    'NumberTitle', 'off', 'Name', '');
img = imagesc(S(:,:,params.initialChannel,params.initialFrame), clims);
colormap(cmap)
axis equal
axis tight
if params.colorbar
    colorbar('Ticks', clims);
end
ax = fig.CurrentAxes;
if ~params.ticks
    ax.XAxis.Visible = 'off';
    ax.YAxis.Visible = 'off';
end
title_h = title('');

% Playback
fig.UserData.idx = params.initialFrame;
fig.UserData.channel = params.initialChannel;
fig.UserData.isPlaying = false;
fig.UserData.fps = params.fps;
fig.UserData.stride = params.stride;

% Misc
fig.UserData.params = params;
fig.UserData.numFrames = numFrames;
fig.UserData.numChannels = numChannels;
fig.UserData.callbacks = callbacks;
fig.UserData.ax = ax;
fig.UserData.title = title_h;
fig.UserData.img = img;
fig.UserData.stackName = params.stackName;
fig.UserData.saved = cell(numFrames,1);
fig.UserData.hotkeys = struct(); % fieldname = key, value = func handle

% Controls
fig.UserData.replot = @replot;
fig.UserData.play = @play;
fig.UserData.playTo = @playTo;
fig.UserData.getSaved = @getSaved;
fig.UserData.toggleSaving = @toggleSaving;
fig.UserData.addHotkey = @addHotkey;

% Add hotkeys
addHotkey('space', @play)
addHotkey('uparrow', @()incFPS(+5))
addHotkey('downarrow', @()incFPS(-5))
addHotkey('add', @()incStride(+1))
addHotkey('subtract', @()incStride(-1))
addHotkey('pageup', @()incChannel(+1))
addHotkey('pagedown', @()incChannel(-1))
addHotkey('home', @()replot(1))
addHotkey('end', @()replot(fig.UserData.numFrames))
% addHotkey('other', @(key,mods)printf('Key: ''%s'', Modifiers: ''%s''',key,strjoin(mods,',')));

% Tighten figure
if params.tight; tightfig; end

% Plot first frame
drawnow;
replot(params.initialFrame);

% Autoplay
if params.autoplay; drawnow; play(); end

if nargout > 0
    h_fig = fig;
    h_img = img;
end

    function KeyPressCB(h, evt)
        isShift = ismember('shift', evt.Modifier);
        isCtrl = ismember('control', evt.Modifier);
        
        switch evt.Key
            case 'leftarrow'
                dt = prod(max([10 * isShift, 50 * isCtrl], 1));
                replot(fig.UserData.idx - dt);
            case 'rightarrow'
                dt = prod(max([10 * isShift, 50 * isCtrl], 1));
                replot(fig.UserData.idx + dt);
            otherwise
                if any(strcmpi(evt.Key, fieldnames(fig.UserData.hotkeys)))
                    if nargin(fig.UserData.hotkeys.(evt.Key)) == 0
                        fig.UserData.hotkeys.(evt.Key)();
                    else
                        fig.UserData.hotkeys.(evt.Key)(fig, fig.UserData.idx);
                    end
                elseif any(strcmpi('other', fieldnames(fig.UserData.hotkeys)))
                    if nargin(fig.UserData.hotkeys.other) == 1
                        fig.UserData.hotkeys.other(evt.Key);
                    else
                        fig.UserData.hotkeys.other(evt.Key, evt.Modifier);
                    end
                end
        end
    end
    function addHotkey(key, fun)
        fig.UserData.hotkeys.(key) = fun;
    end
    function play()
        fig.UserData.isPlaying = ~fig.UserData.isPlaying;
        if ~fig.UserData.isPlaying
            updateTitles()
            return
        end
        while ishghandle(fig) && fig.UserData.isPlaying
            % Draw next frame
            replot(fig.UserData.idx+fig.UserData.stride)
            
            % Wait
            pause(fig.UserData.stride/fig.UserData.fps)
        end
    end
    function playTo(stop_idx)
        % Plays until specified frame and then stops
        if nargin < 1; stop_idx = fig.UserData.numFrames; end
        if fig.UserData.isPlaying; play(); end % stop if already playing
        for i = fig.UserData.idx:fig.UserData.stride:stop_idx
            replot(i);
        end
    end
    function setFPS(new_fps)
        fig.UserData.fps = new_fps;
    end
    function incFPS(delta_fps)
        fig.UserData.fps = max(fig.UserData.fps + delta_fps, 1);
        if ~fig.UserData.isPlaying; play(); end
    end
    function incChannel(delta_channel)
        c = fig.UserData.channel;
        fig.UserData.channel = mod(c-1 + delta_channel, fig.UserData.numChannels)+1;
        replot();
    end
    function incStride(delta_stride)
        fig.UserData.stride = max(fig.UserData.stride + delta_stride, 1);
    end
    function saved = getSaved()
        saved = validate_stack(fig.UserData.saved);
        params.save = false;
    end
    function toggleSaving(state)
        if nargin < 1; state = ~fig.UserData.isPlaying; end
        fig.UserData.isPlaying = state;
    end
    function updateTitles(fig_only)
        if nargin < 1; fig_only = false; end
        title_str = sprintf('%d/%d', fig.UserData.idx, fig.UserData.numFrames);
        if fig.UserData.numChannels > 1 && ~params.autotile
            title_str = sprintf('%s (C: %d/%d)', title_str, fig.UserData.channel, fig.UserData.numChannels);
        end
        if ~fig_only
            title_h.String = title_str;
        end
        if ~isempty(fig.UserData.stackName)
            title_str = sprintf('%s: %s', fig.UserData.stackName, title_str);
        end
        if fig.UserData.isPlaying
            title_str = sprintf('%s [%d FPS / %d stride]', title_str, fig.UserData.fps, fig.UserData.stride);
        end
        if params.save
            title_str = sprintf('%s [Saved %d/%d]', title_str, sum(~areempty(fig.UserData.saved)), fig.UserData.numFrames);
        end
        fig.Name = title_str;
    end
    function replot(idx)
        if nargin < 1; idx = fig.UserData.idx; end
        
        % Update frame index
        idx = mod(idx-1,fig.UserData.numFrames)+1;
        img.UserData.idx = idx;
        fig.UserData.idx = idx;
        
        % Get frame to display
        frame = S(:,:,fig.UserData.channel,idx);
        if params.autotile
            frame = imtile(S(:,:,:,idx));
        end
        
        % Update displayed frame
        img.CData = frame;
        
        % Keep a copy of the image data in the UserData property for convenience
        fig.UserData.frame = frame;
        
        % Update titles
        updateTitles()
        
        % Clear old graphics
        if params.clear
            isImage = arrayfun(@(x) isa(x,'matlab.graphics.primitive.Image'), img.Parent.Children);
            delete(img.Parent.Children(~isImage))
        end
        
        % Invoke callbacks
        fig.CurrentAxes = fig.UserData.ax;
        hold on
        for j = 1:numel(fig.UserData.callbacks)
            args = {fig, idx};
            if nargout(fig.UserData.callbacks{j}) < 1
                fig.UserData.callbacks{j}(args{:});
            else % update frame if there's anything returned
                frame = fig.UserData.callbacks{j}(args{:});
                img.CData = frame;
                fig.UserData.frame = frame;
            end
        end
%         hold off
        
        % Redraw graphics
        drawnow;
        
        % Save frame
        if params.save
            if ischar(params.saveTarget)
                switch params.saveTarget
                    case 'fig'
                        params.saveTarget = fig;
                    case 'ax'
                        params.saveTarget = fig.UserData.ax;
                end
            end
            fig.UserData.saved{idx} = frame2im(getframe(params.saveTarget));
            updateTitles(true)
        end
    end
    function OnClose(h, evt)
        % Prevent error from quitting while playing
        fig.UserData.isPlaying = false;
        delete(h)
    end

end

