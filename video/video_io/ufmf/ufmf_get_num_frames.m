function num_frames = ufmf_get_num_frames(filename)
%UFMF_GET_DURATION Returns the number of frames in an UFMF video.
% Usage:
%   num_frames = ufmf_get_num_frames(filename)

% Read the file header
header = ufmf_read_header(filename);

% Return the number of frames
num_frames = header.nframes;

end

