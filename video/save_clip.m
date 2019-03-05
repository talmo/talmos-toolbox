function save_clip(video_filename, varargin)
%SAVE_CLIP Saves a clip from a fly video.
% Supports all video formats including FMF and UFMF.
%
% Usage:
%   save_clip(video_filename)
%   save_clip(video_filename, 'Name', Value, ...)
%
% Parameters ('Name', Default):
%   'ClipFilename', 'clip.avi';   % The filename of the output movie file
%   'Start', 1;                   % Start frame of the clip
%   'End', 1000;                  % End frame of the clip
%   'PreFlank', 0;                % Frames before the start frame
%   'PostFlank', 0;               % Frames after the end frame
%
%   'Quality', 100;               % Quality of output video
%   'FPS', 15;                    % Frames per second of output video
%   'Profile', 'Motion JPEG AVI'; % Compression profile to use (see VideoWriter)
%
%   'DrawTracks', true;           % Draw tracks behind flies
%   'DrawCentroid', true;         % Draw centroid at the center of fly bodies
%   'CentroidRadius', 3;          % Size of the centroid
%   'DrawWings', true;            % Draw wings
%   'DrawBody', false;            % Draw body (not yet implemented)
%   'DrawTimestamp', true;        % Draw timestamp on movie
%   'TrailLength', 50; % frames   % Number of frames to draw tracking trail for
%   'Colors', {[1 0 0], [0 0 1]}; % Cell array with colors to draw each fly ([r g b])
%
% Example:
%   save_clip('fly_video.fmf', 'Start', 2342, 'End', 2342+409, 'FPS', 20, 'DrawTracks', true, 'DrawTimestamp', true)
%
% See also:
%   save_bout_video, VideoWriter

write_timer = tic;

% Video file
if nargin < 1
    video_filename = uigetvideo();
end

% Parameters
defaults.ClipFilename = 'clip.avi';
defaults.Start = 1;
defaults.End = 1000;
defaults.PreFlank = 0;
defaults.PostFlank = 0;

defaults.Quality = 100;
defaults.FPS = 15;
defaults.Profile = 'Motion JPEG AVI';

defaults.DrawTracks = true;
defaults.DrawCentroid = true;
defaults.CentroidRadius = 3;
defaults.DrawWings = true;
defaults.DrawBody = false;
defaults.DrawTimestamp = true;
defaults.TrailLength = 50;
defaults.Colors = {[1 0 0], [0 0 1]};

[params, unmatched] = parse_params(varargin, defaults);

% Create VideoWriter instance
writer = VideoWriter(get_new_filename(params.ClipFilename), params.Profile);

% Set VideoWriter options
writer.Quality = params.Quality;
writer.FrameRate = params.FPS;
if ~isemptystruct(unmatched)
    VideoWriter_args = struct2nameval(unmatched);
    set(writer, VideoWriter_args{:});
end

% Create bout from clip
bout = struct();
bout.video = video_filename;
bout.start_frame = params.Start;
bout.end_frame = params.End;
bout.fly = 1;

% Open video
video_file = bout.video; if iscell(video_file); video_file = video_file{1}; end
vinfo = video_open(video_file);

% Get tracks
tracks = get_bout_tracks(bout, 'PreFlank', params.PreFlank, 'PostFlank', params.PostFlank);
if isempty(tracks)
    warning('No tracking data found. Tracks will not be rendered.');
    params.DrawTracks = false;
end

% Open file for writing
writer.open();

% Frame indexing
start_frame = max(bout.start_frame - params.PreFlank, 1);
end_frame = min(bout.end_frame + params.PostFlank, vinfo.n_frames);
video_idx = start_frame:end_frame - 1;
num_frames = numel(video_idx);
bout_idx = video_idx - bout.start_frame;
t = bout_idx ./ vinfo.fps;

% Print status
fprintf('<strong>Video</strong>: %s\n', video_file)
fprintf('<strong>Frames</strong>: %d - %d (%d total)\n', start_frame, end_frame, num_frames)
fprintf('<strong>Output</strong>: %s\n', fullfile(writer.Path, writer.Filename))
disp('Rendering, please wait...')

% Write frames
for i = 1:num_frames
    % Get raw video frame
    frame = video_read_frame(vinfo, video_idx(i) - 1);
    
    % Draw tracks
    if params.DrawTracks
        for f = 1:numel(tracks)
            color = params.Colors{f};
            lwing = [tracks(f).xwingl(i) tracks(f).ywingl(i)];
            rwing = [tracks(f).xwingr(i) tracks(f).ywingr(i)];
            centroid = [tracks(f).x(i), tracks(f).y(i)];

            % Draw trail
            if params.TrailLength > 0
                trail_idx = max(1, i - params.TrailLength + 1):i;
                if numel(trail_idx) > 1
                    trail = [tracks(f).x(trail_idx); ...
                             tracks(f).y(trail_idx)];
                    trail = reshape(trail, 1, []);
                    frame = insertShape(frame, 'Line', trail, 'Color', color, 'LineWidth', 1);
                end
            end

            % Draw body
            if params.DrawBody

            end

            % Draw wings
            if params.DrawWings
                % Check for missing wings
                wing_line = centroid;
                if ~any(isnan(lwing) | isinf(lwing))
                    wing_line = [lwing, wing_line];
                end
                if ~any(isnan(rwing) | isinf(rwing))
                    wing_line = [wing_line, rwing];
                end
                if numel(wing_line) > 2
                    frame = insertShape(frame, 'Line', wing_line, 'Color', color);
                end
            end

            % Draw centroid
            if params.DrawCentroid
                frame = insertShape(frame, 'FilledCircle', [centroid, params.CentroidRadius], 'Color', color);
            end
        end
    end
    
    % Draw timestamp
    if params.DrawTimestamp
        timestamp = sprintf('t = %.3f s', t(i));
        frame = insertText(frame, [5, 5], timestamp, 'AnchorPoint', 'LeftTop', 'BoxOpacity', 0, 'BoxColor', 'white', 'FontSize', 16);
    end
    
    % Write to video file
    writer.writeVideo(frame);
end


% Close files
writer.close();
video_close(vinfo);

fprintf('Wrote %d frames to ''%s''. [%.2fs]\n', ...
    writer.FrameCount, fullfile(writer.Path, writer.Filename), toc(write_timer))

end

