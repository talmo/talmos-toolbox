function info = vidinfo(filepath, varargin)
%VIDINFO Returns metadata about a media file using ffprobe.
% Usage:
%   info = vidinfo(filepath)
%   info = vidinfo(filepath, '-count_frames', ...)
% 
% Args:
%   filepath: path to video file
%   args: any additional arguments will be passed as flags to ffprobe (see
%         docs for reference)
%
% Returns:
%   info: structure containing media metadata
% 
% See also: write_frames_ffmpeg

if (iscellstr(filepath) || isstring(filepath)) && numel(filepath) > 1
    if numel(filepath) > 1; info = cellfun(@(x)vidinfo(x,varargin{:}),filepath); return; end
end
if iscell(filepath); filepath = filepath{1}; end

if ~exists(filepath); error('Path does not exist: %s', filepath); end

cmd = [{
    'ffprobe'
    '-hide_banner'
    '-v quiet'
    '-print_format json'
    '-show_format'
    '-show_streams'
    }
    varargin(:)
    {['"' char(filepath) '"']}
    ];

cmd = strjoin(cmd, ' ');
try
    [~,out] = jsystem(cmd);
catch
    [~,out] = system(cmd);
end

info = jsondecode(out);
info.path = filepath;
info.cmd = cmd;
if iscell(info.streams); info.streams = cellcat(info.streams); end

end
