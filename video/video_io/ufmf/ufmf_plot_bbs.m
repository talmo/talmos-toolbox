function [num_bbs, header] = ufmf_plot_bbs(filename)
%UFMF_PLOT_BBS Displays a plot of the number of bounding boxes for a UFMF video.
% Usage:
%   ufmf_plot_bbs
%   ufmf_plot_bbs(filename)
%   [num_bbs, header] = ufmf_plot_bbs(_)

if nargin < 1
    global last_video_dir;
    if ~ischar(last_video_dir) || ~exists(last_video_dir); last_video_dir = pwd; end
    
    [filename, pathname] = uigetfile('*.ufmf', 'Select a UFMF video...', last_video_dir);
    
    if isempty(filename)
        error('No file selected.')
    end
    
    last_video_dir = pathname;
    filename = fullfile(pathname, filename);
end

% Read header
header = ufmf_read_header(filename);

% Display info about video
disp('<strong>Video Information</strong>')
disp('=================')
fprintf('<strong>Path:</strong> %s\n', filename)
fprintf('<strong>File size:</strong> %s\n', bytes2str(get_filesize(filename)))
fprintf('<strong>Frames:</strong> %d\n', header.nframes)
fprintf('<strong>Duration (min:sec):</strong> %s\n', secstr(ufmf_get_duration(filename), 'MM:SS'))
fprintf('<strong>FPS:</strong> %f\n', ufmf_get_fps(filename))
fprintf('<strong>Resolution:</strong> %dx%d\n', header.nr, header.nc)
disp(' ')

% Count number of bounding boxes per frame
bb_timer = tic;
fprintf('Calculating number of bounding boxes...')
num_bbs = arrayfun(@(x) ufmf_get_num_bb(header, x), 1:header.nframes);
fclose(header.fid);
fprintf(' Done. [%.2fs]\n', toc(bb_timer))

% Display plot
figure
bar(num_bbs)
title(get_filename(filename), 'Interpreter', 'none')
xlabel('Frame Number')
ylabel('Number of bounding boxes')
axis tight

% Don't return anything when there's no output target
if nargout < 1
    clear num_bbs header
end
end

