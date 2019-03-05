function fps = ufmf_get_fps(filename)
%UFMF_GET_FPS Returns the framerate of an FMF file.
% Usage:
%   fps = ufmf_get_fps(filename)

% Get duration and number of frames
[duration, num_frames] = ufmf_get_duration(filename);

% Return frames per second
fps = num_frames / duration;

end

