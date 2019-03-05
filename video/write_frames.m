function write_frames(frames, filename, varargin)
%WRITE_FRAMES Saves frames to a video file.
% Usage:
%   write_frames(frames)
%   write_frames(frames, filename)
%   write_frames(frames, filename, 'Name', Val)
%
% Args:
%   frames: 3-D (image stack) or 4-D (timeseries) numeric array, or
%       array frame structure (getframe())
%   filename: name of the video file to write to
%
% Params:
%   Quality: video quality (default = 100)
%   FPS: frame rate for video playback (default = 15)
%   Profile: the VideoWriter profile (default = 'Motion JPEG AVI')
%       'MPEG-4' or 'Uncompressed AVI'
%   Any other VideoWriter properties.
%
% Note: This is a wrapper for the VideoWriter class.
%
% See also: save_bout_video, VideoWriter

write_timer = tic;

% Validate frames
if iscell(frames)
    frames = cat(4, frames{:});
elseif isnumeric(frames)
    % Add singleton dimension to image stack
    if ndims(frames) == 3
        frames = permute(frames, [1 2 4 3]);
    end
    
    assert(~isempty(frames) && ndims(frames) == 4, ...
        'Frames must be non-empty 3 or 4-D numeric array.')
elseif isstruct(frames)
    assert(~isemptystruct(frames) && all(isfield(frames, 'cdata', 'colormap')), ...
        'Frames structure must be non-empty and contain ''cdata'' and ''colormap'' fields.')
else
    error('Unsupported frames type.')
end

% Parameters
defaults.overwrite = true;
defaults.Quality = 100;
defaults.FPS = 15;
defaults.Profile = 'Motion JPEG AVI';
if strcmp(get_ext(filename), '.mp4')
    defaults.Profile = 'MPEG-4';
end
[params, unmatched] = parse_params(varargin, defaults);

if ~params.overwrite
    filename = get_new_filename(filename);
end

% Create VideoWriter instance
writer = VideoWriter(filename, params.Profile);

% Set VideoWriter options
if ~strcmpi(params.Profile, 'Uncompressed AVI')
    writer.Quality = params.Quality;
end
writer.FrameRate = params.FPS;
if ~isemptystruct(unmatched)
    VideoWriter_args = struct2nameval(unmatched);
    set(writer, VideoWriter_args{:});
end

% Open file for writing
writer.open();

% Write frames
writer.writeVideo(frames);

% Close file
writer.close();

videoPath = fullfile(writer.Path, writer.Filename);
printf('Wrote *%d* frames (*%s*) [*%.2fs*]:\n  %s', ...
    writer.FrameCount, bytes2str(get_filesize(videoPath)), ...
    toc(write_timer), videoPath)

end

