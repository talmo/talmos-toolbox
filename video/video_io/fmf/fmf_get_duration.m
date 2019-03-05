function [duration, num_frames] = fmf_get_duration(filename)
%FMF_GET_DURATION Returns the duration of the FMF video in seconds.
% Usage:
%   duration = fmf_get_duration(filename)
%   [duration, num_frames] = fmf_get_duration(filename)
% 
% See also: fmf_get_fps

% Get the number of frames in the video
num_frames = fmf_get_num_frames(filename);

% Get the timestamp from the first and last frames
[~, timestamp_start] = fmf_read(filename, 1, 1);
[~, timestamp_end] = fmf_read(filename, num_frames, 1);
duration = timestamp_end - timestamp_start;

end

