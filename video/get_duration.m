function duration = get_duration(filename)
%GET_DURATION Returns the duration of a video in seconds.
% Usage:
%   duration = get_duration(filename)

ext = get_ext(filename);

switch ext
    case '.ufmf'
        duration = ufmf_get_duration(filename);
    case '.fmf'
        duration = fmf_get_duration(filename);
end
end

