function video_path = fmf2video(fmf_path, video_path, varargin)
%FMF2VIDEO Converts an FMF video to another video format.
% Usage:
%   video_path = fmf2video(fmf_path)
%   video_path = fmf2video(fmf_path, video_path)
%
% See also: VideoWriter

% Parse arguments
if nargin < 2 || isempty(video_path)
    video_path = get_new_filename(fullfile(get_filename(fmf_path, true), '.avi'));
end
defaults.fps = fmf_get_fps(fmf_path);
defaults.compression = [];
defaults.quality = 100;
defaults.frames = [0, inf];
defaults.chunk_size = 1024 ^ 3; % bytes
defaults.verbosity = 2;
params = parse_params(varargin, defaults);

% Calculate chunk size
frame_size = prod(fmf_get_resolution(fmf_path));
chunk_frames = floor(params.chunk_size / frame_size);

% Get frame range
max_frames = fmf_get_num_frames(fmf_path);
start_frame = max(min(params.frames), 1);
end_frame = min(max(params.frames), max_frames);
num_frames = end_frame - start_frame + 1;

% Calculate chunks
chunks = start_frame:chunk_frames:end_frame;
num_chunks = numel(chunks);

if params.verbosity > 0
    fprintf('Converting ''%s'' to ''%s'' (%d frames)...\n', get_filename(fmf_path), get_filename(video_path), num_frames)
end
if params.verbosity > 1
    fprintf('Chunk size: %s -> %d frames\n', bytes2str(params.chunk_size), chunk_frames)
    fprintf('Chunks: %d\n', num_chunks)
end

write_timer = tic;

% Create VideoWriter instance
writer = VideoWriter(video_path);

% Set options
writer.Quality = params.quality;
writer.FrameRate = params.fps;

% Open file for writing
writer.open();

for i = 1:num_chunks
    % Chunk frames
    chunk_start = chunks(i);
    chunk_end = min(chunk_start + chunk_frames - 1, end_frame);
    
    % Read frames
    frames = fmf_read_frames(fmf_path, chunk_start, chunk_end, 'verbosity', 0);

    % Write frames
    writer.writeVideo(frames);
    
    if params.verbosity > 1
        time_left = (end_frame - chunk_end) / (chunk_end / toc(write_timer));
        fprintf('Wrote frames %d/%d (chunk %d/%d)... Time left: %s\n', chunk_end, num_frames, i, num_chunks, secstr(time_left))
    end
end

% Close file
writer.close();

% Return path to video
video_path = fullfile(writer.Path, writer.Filename);

if params.verbosity > 0
    total_time = toc(write_timer);
    fprintf('Finished writing ''%s'' (%s). [%.2f frames/s / Total: %.2fs]\n', ...
        writer.Filename, bytes2str(get_filesize(video_path)), num_frames / total_time, total_time)
end

if nargout < 1
    clear video_path
end
end

