function gatherFiles(baseDir, targetDir, copyOnly, regexFilter)
%GATHERFILES Moves files from subdirectories into a single folder.
% Usage:
%   gatherFiles(baseDir)
%   gatherFiles(baseDir, targetDir)
%   gatherFiles(baseDir, targetDir, copyOnly)
%   gatherFiles(baseDir, targetDir, copyOnly, regexFilter)
% 
% Args:
%   baseDir: base directory where files are stored
%   targetDir: where to gather to (default = pwd)
%   copyOnly: copies files without deleting the originals (default = true)
%   regexFilter: excludes files that do not match (default = '.*')
%       If a cell array of strings is specified, will build a regex pattern
%       to match those extensions. Extensions may contain wildcards.

if nargin < 2 || isempty(targetDir); targetDir = pwd; end
if nargin < 3 || isempty(copyOnly); copyOnly = true; end
if nargin < 4 || isempty(regexFilter); regexFilter = '.*'; end

% Get file listing
[files, ~] = dirAll(baseDir);
if isempty(files)
    warning('Could not find any files to move.')
    return
end

% Build pattern for a list of extensions
if iscellstr(regexFilter)
    regexFilter = regexprep(regexFilter, '^\.', ''); % remove leading .
    regexFilter = strrep(regexFilter, '*', '[^\\/]*'); % expand wildcard to regex
    exts = strjoin(regexFilter, '|');
    regexFilter = ['\.(' exts ')$'];
end

% Filter files
matches = regexpi(files, regexFilter);
files = files(~areempty(matches));
fprintf('Found %d/%d files that matched the filter: %s\n', ...
    numel(files), numel(matches), regexFilter)

% Create target directory if it doesn't exist
targetDir = abspath(targetDir);
if ~exists(targetDir); mkdir(targetDir); end

% Filter out files already in the target path
targetFiles = dir_files(targetDir, true);
inTarget = ismember(files, targetFiles);
if sum(inTarget) > 0
    files = files(~inTarget);
    fprintf('Excluded %d files that were already in the target folder.\n', ...
        sum(inTarget))
end

% Handle an annoying warning
w = warning('query', 'MATLAB:dispatcher:nameConflict');
warning('off', 'MATLAB:dispatcher:nameConflict');

% Do the thing
success = false(size(files));
for i = 1:numel(files)
    if copyOnly
        [status, message] = copyfile(files{i}, targetDir);
    else
        [status, message] = movefile(files{i}, targetDir);
    end
    if status == 0
        warning('Could not gather %s:\n\t%s\n', files{i}, message)
    end
    success(i) = status;
end

% Reset the warning
warning(w.state, 'MATLAB:dispatcher:nameConflict');

% Print a message
verb = 'Copied';
if ~copyOnly; verb = 'Moved'; end

fprintf('%s %d/%d files in: <strong>%s</strong>\nTo: <strong>%s</strong>.\n', ...
    verb, sum(success), numel(files), baseDir, targetDir)
end

