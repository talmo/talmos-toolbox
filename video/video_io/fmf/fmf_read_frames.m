function frames = fmf_read_frames(video_path, start_frame, end_frame, varargin)
%FMF_READ_FRAMES Reads video frames of an FMF video.
% Notes:
%   - 1 to N frame indexing
%   - frames = [height, width, 1, num_frames]

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

% Parse parameters
defaults.verbosity = 1;
params = parse_params(varargin, defaults);

% Read file header
fmf = fmf_header(video_path);
max_frames = fmf.n_frames;

% Calculate frame range
if isempty(start_frame); start_frame = 1; end
if isempty(end_frame); end_frame = max_frames; end
end_frame = min(end_frame, max_frames);
start_frame = min(max(1, start_frame), end_frame);
num_frames = end_frame - start_frame + 1;

% Calculate indexing information
frm_sz = prod(fmf.fmf.framesize);
chunk_skip = fmf.fmf.chunksize - frm_sz;

if params.verbosity > 0
    fprintf('Reading %d frames of ''%s''...\n', num_frames, video_path)
end
if params.verbosity > 1
    fprintf('Start frame: %d\n', start_frame)
    fprintf('End frame: %d\n', end_frame)
    fprintf('Size: %d bytes (uint8)\n', frm_sz * num_frames)
end

% Initialize
video_read_timer = tic;
frames = zeros(fmf.sx, fmf.sy, num_frames, 'uint8');
fileID = fopen(fmf.filename, 'r');

% Read frames
for f = 1:num_frames
    % Position is based on C-style indexing (0 to N-1)
    pos = (start_frame + f - 2) * fmf.fmf.chunksize + chunk_skip;
    fseek(fileID, fmf.fmf.header_bytes + pos, 'bof');
    
    % Read as uint8
    data = fread(fileID, frm_sz, '*uint8');
    
    % Format matrix
    data = permute(reshape(data, [fmf.sz fmf.sy fmf.sx]), [3 2 1]);
    frames(:, :, f) = data;
    
    if params.verbosity > 0 && mod(f, 1000) == 0
        fprintf('Read %d/%d...\n', f, num_frames)
    end
end

% Close file
fclose(fileID);

% Reshape frames into [height, width, 1, num_frames]
frames = permute(frames, [1 2 4 3]);

if params.verbosity > 0
    fprintf('Read %d frames (%s). [%.2fs]\n', size(frames, 4), bytes2str(varsize(frames)), toc(video_read_timer))
end
end

