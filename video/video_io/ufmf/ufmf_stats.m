function ufmf = ufmf_stats(path)
%UFMF_STATS Returns some measures of the UFMF parameters.
% Usage:
%   ufmf = ufmf_stats
%   ufmf = ufmf_stats(path)
%   ufmf = ufmf_stats(header)
%
% See also: ufmf_plot_stats

% Browse for path
if nargin < 1
    global last_video_dir;
    if ~ischar(last_video_dir) || ~exists(last_video_dir); last_video_dir = pwd; end
    
    [path, pathname] = uigetfile('*.ufmf', 'Select a UFMF video...', last_video_dir);
    
    if isempty(path)
        error('No file selected.')
    end
    
    last_video_dir = pathname;
    path = fullfile(pathname, path);
end

% Get header
ufmf.header = path;
if ischar(path)
    ufmf.header = ufmf_read_header(path);
end

% Basic info
ufmf.path = ufmf.header.filename;
ufmf.filesize = get_filesize(ufmf.path);
ufmf.num_frames = ufmf.header.nframes;
ufmf.num_keyframes = ufmf.header.nmeans;
ufmf.duration = ufmf.header.timestamps(end) - ufmf.header.timestamps(1);
ufmf.resolution = [ufmf.header.nr, ufmf.header.nc];
ufmf.fps = ufmf.num_frames / ufmf.duration;

% Efficiency
ufmf.kbps = (ufmf.filesize / 1024) / ufmf.duration;

% Background model
ufmf.bg.keyframes = arrayfun(@(x) find(ufmf.header.frame2mean == x, 1), unique(ufmf.header.frame2mean));
ufmf.bg.dFrames = diff(ufmf.bg.keyframes);
ufmf.bg.dT = diff(ufmf.bg.keyframes);
ufmf.bg.num_boxes = arrayfun(@(f) ufmf_get_num_bb(ufmf.header, f), 1:ufmf.num_frames);

% Summary stats about background model
ufmf.bg_max_boxes = max(ufmf.bg.num_boxes);
ufmf.bg_avg_boxes = mean(ufmf.bg.num_boxes);
ufmf.bg_avg_dT = mean(ufmf.bg.dT);

% Close file handle
fclose(ufmf.header.fid);

end

