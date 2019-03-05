function filepath = searchFor(query, searchPath, k, maxLevels)
%SEARCHFOR Searches for a specified file within a directory recursively.
% Usage:
%   filepath = searchFor(query)
%   filepath = searchFor(query, searchPath)
%   filepath = searchFor(query, searchPath, k)
%   filepath = searchFor(query, searchPath, k, maxLevels)
% 
% Args:
%   query: filename (including wildcards) to search for
%   searchPath: path to directory to search in (default = pwd)
%   k: number of results to return (default = inf)
%   maxLevels: maximum number of subdirectories to search in (default = inf)
%
% Returns:
%   filepath: path to the result(s)

% Defaults
if nargin < 2 || isempty(searchPath)
    searchPath = pwd;
    if contains(query,'*')
        [searchPath,a,b] = fileparts(query);
        query = [a b];
    end
end
if nargin < 3 || isempty(k); k = inf; end
if nargin < 4 || isempty(maxLevels); maxLevels = inf; end

% Add specified search paths to the search stack
if ~iscell(searchPath); searchPath = {searchPath}; end
dirsToSearch = cf(@abspath,searchPath);

% Search!
filepath = {};
level = 0;
while ~isempty(dirsToSearch)
    hits = cellcat(cf(@(d) dir_files(fullfile(d, query), true), dirsToSearch(:)),1);
    filepath = cat(1, filepath, hits);
    
    if numel(filepath) < k && level < maxLevels
        dirsToSearch = cellcat(cf(@(d) dir_folders(d, true), dirsToSearch(:)));
        level = level + 1;
    else
        break;
    end
end

filepath = natsortfiles(filepath);

if numel(filepath) > k
    filepath = filepath(1:k);
end

if numel(filepath) == 1
    filepath = filepath{1};
end

end

