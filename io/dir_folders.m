function folders = dir_folders(path, fullPaths)
%DIR_FILES Returns the folders in a directory.
% Usage:
%   paths = dir_folders % lists folder in pwd
%   paths = dir_folders(path)
%   paths = dir_folders(path, true) % returns full paths
%
% See also: dir_files, dir_paths, dir

% Default path
if nargin < 1; path = pwd; end
if nargin < 2; fullPaths = false; end

% Get directory listing
listing = dir(path);
names = {listing.name}';

% Filter relative names ('.' and '..')
rel_names = cellfun(@(x) isequal(x, '.') || isequal(x, '..'), {listing.name});

% Filter folders
folders = names([listing.isdir] & ~rel_names);

% Sort
folders = natsortfiles(folders);

% Return full paths
if fullPaths
    folders = fullfile(path, folders);
end

end

