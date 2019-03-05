function [fig_handle, axes_handle, scroll_bar_handles, playback] = ...
	videofig(num_frames, redraw_func, play_fps, big_scroll, ...
	key_func, stop_func, set_fps_func, varargin)
%VIDEOFIG Figure with horizontal scrollbar and play capabilities.
%   VIDEOFIG(NUM_FRAMES, @REDRAW_FUNC)
%   Creates a figure with a horizontal scrollbar and shortcuts to scroll
%   automatically. The scroll range is 1 to NUM_FRAMES. The function
%   REDRAW_FUNC(F) is called to redraw at scroll position F (for example,
%   REDRAW_FUNC can show the frame F of a video).
%   This can be used not only to play and analyze standard videos, but it
%   also lets you place any custom Matlab plots and graphics on top.
%
%   The keyboard shortcuts are:
%     Enter (Return) -- play/pause video (25 frames-per-second default).
%     Backspace -- play/pause video 5 times slower.
%     Right/left arrow keys -- advance/go back one frame.
%     Page down/page up -- advance/go back 30 frames.
%     Home/end -- go to first/last frame of video.
%
%   Advanced usage
%   --------------
%   VIDEOFIG(NUM_FRAMES, @REDRAW_FUNC, FPS, BIG_SCROLL)
%   Also specifies the speed of the play function (frames-per-second) and
%   the frame step of page up/page down (or empty for defaults).
%
%   VIDEOFIG(NUM_FRAMES, @REDRAW_FUNC, FPS, BIG_SCROLL, @KEY_FUNC)
%   Also calls KEY_FUNC(KEY) with any keys that weren't processed, so you
%   can add more shortcut keys (or empty for none).
%
%   VIDEOFIG(NUM_FRAMES, @REDRAW_FUNC, FPS, BIG_SCROLL, @KEY_FUNC, ...)
%   Passes any additional arguments to the native FIGURE function (for
%   example: 'Name', 'Video figure title').
%
%   [FIG_HANDLE, AX_HANDLE, OTHER_HANDLES, SCROLL] = VIDEOFIG(...)
%   Returns the handles of the figure, drawing axes and other handles (of
%   the scrollbar's graphics), respectively. SCROLL(F) can be called to
%   scroll to frame F, or with no arguments to just redraw the figure.
%
%   Example 1
%   ---------
%   Place this in a file called "redraw.m":
%     function redraw(frame)
%         imshow(['AT3_1m4_' num2str(frame, '%02.0f') '.tif'])
%     end
%
%   Then from a script or the command line, call:
%     videofig(10, @redraw);
%     redraw(1)
%
%   The images "AT3_1m4_01.tif" ... "AT3_1m4_10.tif" are part of the Image
%   Processing Toolbox and there's no need to download them elsewhere.
%
%   Example 2
%   ---------
%   Change the redraw function to visualize the contour of a single cell:
%     function redraw(frame)
%         im = imread(['AT3_1m4_' num2str(frame, '%02.0f') '.tif']);
%         slice = im(210:310, 210:340);
%         [ys, xs] = find(slice < 50 | slice > 100);
%         pos = 210 + median([xs, ys]);
%         siz = 3.5 * std([xs, ys]);
%         imshow(im), hold on
%         rectangle('Position',[pos - siz/2, siz], 'EdgeColor','g', 'Curvature',[1, 1])
%         hold off
%     end
%
%   João Filipe Henriques, 2010
	
	%default parameter values
	if nargin < 3 || isempty(play_fps), play_fps = 25; end  %play speed (frames per second)
	if nargin < 4 || isempty(big_scroll), big_scroll = 30; end  %page-up and page-down advance, in frames
	if nargin < 5, key_func = []; end
    if nargin < 6, stop_func = []; end
    if nargin < 7, set_fps_func = []; end
	
	%check arguments
    
    if isscalar(num_frames)
        validateattributes(num_frames, {'numeric'}, {'numel', 1})
        start_frame = 1;
        end_frame = num_frames;
    else
        validateattributes(num_frames, {'numeric'}, {'numel', 2})
        start_frame = num_frames(1);
        end_frame = num_frames(2);
        num_frames = end_frame - start_frame + 1;
    end
	%check_int_scalar(num_frames);
	check_callback(redraw_func);
	%check_int_scalar(play_fps);
    validateattributes(play_fps, {'numeric'}, {'scalar'});
    original_fps = play_fps;
	check_int_scalar(big_scroll);
	check_callback(key_func);
    check_callback(stop_func);
    check_callback(set_fps_func);

	click = 0;
	f = start_frame;  %current frame
	
	%initialize figure
	fig_handle = figure('Color',[.3 .3 .3], 'MenuBar','none', 'Units','norm', ...
		'WindowButtonDownFcn',@button_down, 'WindowButtonUpFcn',@button_up, ...
		'WindowButtonMotionFcn', @on_click, 'KeyPressFcn', @key_press, ...
        'WindowScrollWheelFcn', @mouse_scroll, varargin{:}, 'CloseRequestFcn', @fig_close);
	
	%axes for scroll bar
	scroll_axes_handle = axes('Parent',fig_handle, 'Position',[0 0 1 0.04], ...
		'Visible','off', 'Units', 'normalized');
	axis([0 1 0 1]);
	axis off
	
	%scroll bar
	scroll_bar_width = max(1 / num_frames, 0.01);
	scroll_handle = patch([0 1 1 0] * scroll_bar_width, [0 0 1 1], [.8 .8 .8], ...
		'Parent',scroll_axes_handle, 'EdgeColor', 'w', 'ButtonDownFcn', @on_click);
	
	%timer to play video
    warning('off', 'MATLAB:TIMER:RATEPRECISION')
	play_timer = timer('TimerFcn',@play_timer_callback, 'ExecutionMode','fixedRate', 'StopFcn', @stop_timer_callback);
    
	%main drawing axes for video display
	axes_handle = axes('Position',[0 0.04 1 0.96]);
	
	%return handles
	scroll_bar_handles = [scroll_axes_handle; scroll_handle];
    
    % Playback handles
	playback.scroll = @scroll;
    playback.play = @play;
    playback.pause = @() stop(play_timer);
    playback.set_fps = @set_fps;
    playback.get_fps = @get_fps;
    playback.get_frame = @get_frame;
    playback.is_playing = @is_playing;
    
    function set_fps(new_fps)
        play_fps = max(new_fps, 0.001);
        if is_playing()
            stop(play_timer);
            play()
        end
        if ~isempty(set_fps_func)
            set_fps_func(new_fps);
        end
    end
    function fps = get_fps()
        fps = play_fps;
    end
    function frame = get_frame()
        frame = f;
    end
    function TF = is_playing()
        TF = strcmp(get(play_timer,'Running'), 'on');
    end
	
	function key_press(src, event)  %#ok, unused arguments
        if ~isempty(event.Modifier)
            if ~isempty(key_func),
                key_func(src, event);  %#ok, call custom key handler
                return
            end
        end
		switch event.Key,  %process shortcut keys
            case 'leftarrow',
                scroll(f - 1);
            case 'rightarrow',
                scroll(f + 1);
            case 'uparrow'
                scroll(max(f - big_scroll, start_frame))
            case 'downarrow'
                scroll(min(f + big_scroll, end_frame))
            case 'pagedown'
                set_fps(max(play_fps - 10, 0.1))
            case 'pageup'
                set_fps(play_fps + 10)
            case 'home'
                scroll(start_frame);
            case 'end'
                scroll(num_frames);
            case 'space'
                play()
            case 'return'
                set_fps(original_fps)
            case 'backspace'
                % Toggle slow mode
                if play_fps == original_fps
                    set_fps(original_fps * 0.1);
                else
                    set_fps(original_fps);
                end
            otherwise
                if ~isempty(key_func),
                    key_func(src, event);  %#ok, call custom key handler
                end
		end
	end
	
	%mouse handler
	function button_down(src, event)  %#ok, unused arguments
		set(src,'Units','norm')
		click_pos = get(src, 'CurrentPoint');
		if click_pos(2) <= 0.04,  %only trigger if the scrollbar was clicked
			click = 1;
			on_click([],[]);
		end
	end

	function button_up(src, event)  %#ok, unused arguments
		click = 0;
	end

	function on_click(src, event)  %#ok, unused arguments
		if click == 0, return; end
		
		%get x-coordinate of click
		set(fig_handle, 'Units', 'normalized');
		click_point = get(fig_handle, 'CurrentPoint');
		set(fig_handle, 'Units', 'pixels');
		x = click_point(1);
		
		%get corresponding frame number
		new_f = floor(start_frame + x * num_frames);
		
		if new_f < start_frame || new_f > end_frame, return; end  %outside valid range
		
		if new_f ~= f,  %don't redraw if the frame is the same (to prevent delays)
			scroll(new_f);
		end
    end

    function mouse_scroll(hObj, event)
        ticks = event.VerticalScrollCount; % down = +1, up = -1
        set_fps(play_fps - ticks * 5);
    end

	function play()
        % Restart video if it's at the end
        if f == end_frame
            f = start_frame;
        end
        
		%toggle between stoping and starting the "play video" timer
		if strcmp(get(play_timer,'Running'), 'off'),
			set(play_timer, 'Period', 1 / play_fps);
            %fprintf('play_fps = %f, timer = %f \n', play_fps, 1/get(play_timer, 'Period'))
			start(play_timer);
		else
			stop(play_timer);
		end
	end
	function play_timer_callback(src, event)  %#ok
		%executed at each timer period, when playing the video
		if f < end_frame
			scroll(f + 1);
		elseif strcmp(get(play_timer,'Running'), 'on')
			stop(play_timer);  %stop the timer if the end is reached
		end
	end
    function stop_timer_callback(src, event)
        if ~isempty(stop_func)
            stop_func(src, event);
        end
    end
	function scroll(new_f)
		if nargin == 1,  %scroll to another position (new_f)
			if new_f < start_frame || new_f > end_frame
				return
			end
			f = new_f;
		end
		
		%convert frame number to appropriate x-coordinate of scroll bar
		scroll_x = (f - start_frame) / num_frames;
		
		%move scroll bar to new position
		set(scroll_handle, 'XData', scroll_x + [0 1 1 0] * scroll_bar_width);
		
		%set to the right axes and call the custom redraw function
		set(fig_handle, 'CurrentAxes', axes_handle);
		redraw_func(f);
		
		%used to be "drawnow", but when called rapidly and the CPU is busy
		%it didn't let Matlab process events properly (ie, close figure).
		pause(0.001)
	end
	
	%convenience functions for argument checks
	function check_int_scalar(a)
		assert(isnumeric(a) && isscalar(a) && isfinite(a) && a == round(a), ...
			[upper(inputname(1)) ' must be a scalar integer number.']);
	end
	function check_callback(a)
		assert(isempty(a) || strcmp(class(a), 'function_handle'), ...
			[upper(inputname(1)) ' must be a valid function handle.'])
    end

    function fig_close(hObj, event)
        % Turn timer precision warning back on
        warning('on', 'MATLAB:TIMER:RATEPRECISION');
        
        % Delete timer
        if exist('play_timer', 'var')
            stop(play_timer);
            delete(play_timer);
            %waitfor(play_timer);
        end
        
        % Delete figure if it still exists
        if isfig(hObj)
            delete(hObj);
        end
    end
end

