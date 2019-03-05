function [duration, num_frames] = ufmf_get_duration(filename)
%UFMF_GET_DURATION Returns the duration of the UFMF video in seconds.
% Usage:
%   duration = ufmf_get_duration(filename)
%   [duration, num_frames] = ufmf_get_duration(filename)
% 
% See also: ufmf_get_fps

% Read the file header
header = ufmf_read_header(filename);

% Return the relevant fields
duration = header.timestamps(end) - header.timestamps(1);
num_frames = header.nframes;

end

