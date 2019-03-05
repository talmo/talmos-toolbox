function num_frames = fmf_get_num_frames(filename)
%FMF_GET_NUM_FRAMES Returns the number of frames in an fmf video.
% Usage:
%   num_frames = fmf_get_num_frames(filename)

% Get the number of frames in the video from the header
[~, ~, ~, ~, ~, num_frames, ~] = fmf_read_header(filename);

end

