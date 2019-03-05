function fps = fmf_get_fps(filename)
%FMF_GET_FPS Returns the framerate of an FMF file.
% Usage:
%   fps = fmf_get_fps(filename)
%
% See also: fmf_get_duration

% Get duration and number of frames
[duration, num_frames] = fmf_get_duration(filename);

% Return frames per second
fps = num_frames / duration;

end

