function fps = get_fps(filename)
%GET_FPS Returns the FPS of the video.
% Usage:
%   fps = get_fps(filename)

ext = get_ext(filename);

switch ext
    case '.ufmf'
        fps = ufmf_get_fps(filename);
    case '.fmf'
        fps = fmf_get_fps(filename);
    otherwise
        vinfo = video_open(filename);
        fps = vinfo.fps;
        video_close(vinfo);
end
end

