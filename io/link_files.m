function link_files(source, destination, type)
%LINK_FILES Creates a link between two files.
% Usage:
%   link_files(source, destination)
%
% Args:
%   source: path to original file
%   destination: path to link (new file)
%   type: create 'soft' or 'hard' link (default: 'soft')
%
% Notes:
%   - For *nix, link is created with ln [-s]
%   - For Windows, link is created with: mklink [/h]

% Get absolute paths
source = GetFullPath(source);
destination = GetFullPath(destination);

% Check if source exists
if ~exists(source)
    error('Link source does not exist.')
end

% Check if destination exists
if exists(destination)
    error('Link destination already exists.')
end

% Check link type
if nargin < 3; type = 'soft'; end
type = validatestring(type, {'soft', 'hard'});

% Create link
link_type = '';
if isunix
    % Link type flag
    if strcmp(type, 'soft'); link_type = '-s '; end
    
    % Run command
    cmd = sprintf('ln %s"%s" "%s"', link_type, source, destination);
    [status, output] = unix(cmd);
    
elseif ispc
    % Link type flag
    if strcmp(type, 'hard'); link_type = '/h '; end
    
    % Run command
    cmd = sprintf('mklink %s"%s" "%s"', link_type, destination, source);
    [status, output] = system(cmd);
    
else
    error('Unsupported operating system.')
end

% Check for error
if status ~= 0
    error('Failed to create link: %s\nSource: %s\nDestination: %s', output, source, destination)
end

% Reading symlink on Unix:
%   [status, output] = unix(sprintf('readlink "%s"', link_path));
%   - output will contain the path that the link points to. This contains
%     the path used to create it, so it may be relative.
%   - If the path is not a symlink, output is empty, even if the path is to
%     the destination of the link).
%   - Calling this on the destination of the link does nothing.
%
% Reading hardlink on Windows:
%   [status, output] = system(sprintf('fsutil hardlink list "%s"', path))
%   - status will be 0 if the path exists, 1 if it does not
%   - output will contain all of the paths that point to this file, but the
%     paths will be missing the drive name.
    
end

