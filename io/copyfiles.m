function copied = copyfiles(files, target, basePath)
%COPYFILES Copies files preserving the original directory tree.
% Usage:
%   copyfiles(file)  % char
%   copyfiles(files) % cellstr
%   copyfiles(files, target)
%   copyfiles(files, target, basePath)
%   copied = copyfiles(_)
%
% Args:
%   files: path to one or more files to be copied
%   target: destination path to copy to (default = pwd)
%   basePath: start of directory tree (default = findprefix(files))
%
% Returns:
%   copied: paths to the copied files
%   
% See also: gatherFiles, findprefix, ttcopydeps

% Parse inputs
if ischar(files); files = {files}; end
if ~iscellstr(files); error('Files must be specified as a cell string.'); end
if nargin < 2 || isempty(target); target = pwd; end
if nargin < 3; basePath = findprefix(files); end

% Separate files and folders
folders = files(isfolder(files));
files = files(isfile(files));

% Get rid of prefix
srcFiles = files;
files = vert(strrep(files, basePath, ''));
folders = vert(strrep(folders, basePath, ''));

% Add folders from file directory tree
folders = unique([folders; cf(@fileparts, files)]);

% Add target path
files = fullfile(target, files);
folders = fullfile(target, folders);

% Create new folders
newFolders = folders(~exists(folders, true));
for i = 1:numel(newFolders)
    mkdir(newFolders{i})
end

% Copy the files
for i = 1:numel(files)
    try
        copyfile(srcFiles{i}, files{i}, 'f')
    catch ME
        warning('Error copying: %s\n%s', srcFiles{i}, ME.getReport())
    end
end

if nargout > 0
    copied = files;
end
end

