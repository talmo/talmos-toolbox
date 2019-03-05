function path = uigetvideo(start_dir)
%UIGETVIDEO Displays dialog to select a video file.
% Usage:
%   path = uigetvideo
%   path = uigetvideo(start_dir)
%
% See also: uibrowse, get_video_exts, ext2filter_spec

if nargin < 1
    start_dir = []; % use last directory
end

% Create filter specification
filter_spec = {ext2filter_spec(get_video_exts()), 'Supported video files'};

% Display file browser
path = uibrowse(filter_spec, start_dir, 'Select video file...');


end

