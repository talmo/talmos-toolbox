function play_fmf(fmf, fps)
%PLAY_FMF Plays an FMF video.
% Usage:
%   play_fmf
%   play_fmf(fmf)
%   play_fmf(fmf, fps)

% Browse for file
if nargin < 1
    fmf = uibrowse('*.fmf');
end

% Get video information
vinfo = video_open(fmf);

% Playback options
big_scroll = 30;
if nargin < 2
    fps = vinfo.fps;
end
show_debug = false;
current_frame = 0;
lag = 0;
%max_lag = 10 / 1000; % secs
last_fired = [];

% Image handle
img_h = []; first_frame = true;

% Show figure
[fig_h, ax_h, other_h, pb] = videofig(vinfo.n_frames, @redraw, fps, big_scroll, [], @timer_stopped);

% Figure title
set(fig_h, 'NumberTitle', 'off')
set(fig_h, 'Name', get_filename(fmf))

% Figure position
fig_units = get(fig_h, 'Units');
set(fig_h, 'Units', 'pixels')
pos = get(fig_h, 'Position');
set(fig_h, 'Position', [pos(1:2), vinfo.sy, vinfo.sx])
set(fig_h, 'Units', fig_units)

% Play video
pb.play()

    % Frame draw callback
    function redraw(frame_num)
        % Get the current FPS
        play_fps = pb.get_fps();
        
        % Skip frame if we're behind
        dt = 0;
        if ~isempty(last_fired)
            dt = toc(last_fired); % latency
            lag = dt - (1 / play_fps);
            %fprintf('latency = %f, expected = %f\n', dt, 1/play_fps)
%             if lag > max_lag
%                 %fprintf('skipped frame, lag = %f\n', lag)
%                 last_fired = tic;
%                 return
%             end
        end
        last_fired = tic;
        
        % Read frame
        frame = fmf_read_frame2(vinfo, frame_num);
        
        % Insert status text into frame
        cur_time = secstr((frame_num / vinfo.n_frames) * vinfo.duration, 'MM:SS');
        total_time = secstr(vinfo.duration, 'MM:SS');
        status = {sprintf('%s/%s', cur_time, total_time), ...
            sprintf('Frame: %d/%d', frame_num, vinfo.n_frames), ...
            sprintf('FPS: %.3f (%sx)', play_fps, num2str(play_fps / vinfo.fps))};
        if show_debug
            status{end + 1} = ...
                sprintf('Actual FPS: %s / Lag: %f ms', num2str(num2str(1/dt)), lag * 1000);
        end
        frame = insertText(frame, [5, 5], strjoin(status, '\n'), ...
            'BoxColor', 'white', 'BoxOpacity', 0.2);
        
        % Draw frame
        if first_frame
            % imshow adjusts axis properties, but is slower
            img_h = imshow(frame, 'Parent', ax_h);
            first_frame = false;
        else
            % Updating just the CData is faster
            set(img_h, 'CData', frame);
        end
        
        % Update current frame
        current_frame = frame_num;
        
    end

    function timer_stopped(~, ~)
        last_fired = [];
    end
end

