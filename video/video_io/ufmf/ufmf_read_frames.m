function frames = ufmf_read_frames(video_path, start_frame, end_frame)
%UFMF_READ_FRAMES Reads video frames of a UFMF video.
% Usage:
%   frames = ufmf_read_frames(video_path, start_frame, end_frame)

if nargin == 2
    if isscalar(start_frame)
        % Single frame
        end_frame = start_frame;
    else
        % start_frame = 1:N
        end_frame = max(start_frame);
        start_frame = min(start_frame);
    end
end

% Read video header
header = ufmf_read_header(video_path);
max_frames = header.nframes;

% Calculate frame range
if isempty(start_frame); start_frame = 1; end
if isempty(end_frame); end_frame = max_frames; end
end_frame = min(end_frame, max_frames);
start_frame = min(max(1, start_frame), end_frame);
num_frames = end_frame - start_frame + 1;

video_read_timer = tic;

% Initialize
frames = zeros(header.nc, header.nr, num_frames, header.dataclass);

% Read frames
frame_range = start_frame:end_frame;
for i = 1:num_frames
    f = frame_range(i);
    frames(:, :, i) = ufmf_read_frame(header, f);
end

% Reshape frames into [height, width, 1, num_frames]
frames = permute(frames, [1 2 4 3]);

fprintf('Read %d frames (%s). [%.2fs]\n', size(frames, 4), bytes2str(varsize(frames)), toc(video_read_timer))

end

