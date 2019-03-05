function files = dir_files(path, fullPaths)
%DIR_FILES Returns the files in a directory.
% Usage:
%   paths = dir_files % returns files in pwd
%   paths = dir_files(path)
%   paths = dir_files(path, true) % returns full paths
%
% See also: dir_folders, dir_paths, dir

% Default path
if nargin < 1; path = pwd; end
if nargin < 2; fullPaths = false; end

% Get absolute path
path = abspath(path);

% Get directory listing
listing = dir(path);
names = {listing.name}';

% Filter files
files = names(~[listing.isdir]);

if fullPaths
    % Remove trailing part if it's not the folder
    if ~isdir(path); path = fileparts(path); end
    
    % Return full paths
    files = fullfile(path, files);
end
end

