function varargout = dirAll(baseDir, maxFolders)
%DIRALL Recursively lists files and folders.
% Usage:
%   dirAll
%   dirAll(baseDir)
%   dirAll(baseDir, maxFolders)
%   paths = dirAll(...)
%   [files, folders] = dirAll(...)
%
% Args:
%   baseDir: directory to search in (default = pwd)
%   maxFolders: max number of folders to search (default = 1000)
%
% See also: dir, dir_files, dir_ext, gatherFiles

if nargin < 1; baseDir = pwd; end
if nargin < 2; maxFolders = 1000; end

searchIn = {abspath(baseDir)};
paths = {};
folders = logical([]);
count = 0;
while count <= maxFolders && ~isempty(searchIn)
    count = count + 1;
    
    % Pop off next search directory
    searchPath = searchIn{1};
    searchIn(1) = [];
    
    % Get listing excluding current and parent directory
    listing = dir(searchPath);
    listing = listing(~ismember({listing.name}, {'.', '..'}));
    
    % Skip if empty
    if isempty(listing); continue; end
    
    % Build paths
    listingPaths = fullfile(searchPath, {listing.name}');
    
    % Add folders to search queue
    isDir = [listing.isdir]';
    searchIn = [searchIn; listingPaths(isDir)];
    
    % Add folders and files to list
    paths = [paths; listingPaths];
    folders = [folders; isDir];
end

switch nargout
    case 0
        for i = 1:numel(paths)
            fprintf('%s\n', paths{i})
        end
    case 1
        varargout = {paths};
    case 2
        varargout = {paths(~folders), paths(folders)};
end

end

