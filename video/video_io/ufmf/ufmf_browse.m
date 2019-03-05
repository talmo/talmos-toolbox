function path = ufmf_browse(start_dir)
%UFMF_BROWSE Helper function to display a file browser dialog.
% Usage:
%   path = ufmf_browse
%   path = ufmf_browse(start_dir)

% Remember last directory
global last_video_dir;
if nargin < 1
    if ~ischar(last_video_dir) || ~exists(last_video_dir); last_video_dir = pwd; end
    start_dir = last_video_dir;
end

% Display dialog
[filename, pathname] = uigetfile('*.ufmf', 'Select a UFMF video...', start_dir);

if isempty(filename)
    error('No file selected.')
end

% Save last dir and return full path
last_video_dir = pathname;
path = fullfile(pathname, filename);

end

