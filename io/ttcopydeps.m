function ttcopydeps(filename, target_folder)
%TTCOPYDEPS Copies the toolbox dependencies of the function or script.
% Usage:
%   ttcopydeps(filename)
%   ttcopydeps(filename, target_folder)
%
% Args:
%   filename: path to function or script
%   target: where depedencies should be copied (default = [])
%           If empty, all dependencies will be copied into a single
%           subfolder called 'private'. if multiple dependencies have the 
%           same name, a warning will be printed.
%           If a string is provided, the directory tree is preserved.
%
% Note: When the target is [] and the deps are copied into the private
% subfolder, nothing needs to be added to the path when using the input
% function.
% 
% Otherwise, 
%
% See also: getdeps, copyfiles

if nargin < 2; target_folder = []; end

% Find dependencies
deps = getdeps(filename);

% Exclude input file
deps = deps(~strcmp(deps, which(filename)));

% Keep only talmos-toolbox dependencies
tt = istt(deps);
if any(~tt)
    warning('The following dependencies will not be copied:\n\t%s', ...
        strjoin(deps(~tt), '\n\t'))
end

% Figure out copy mode
keepDirTree = ~isempty(target_folder);

if keepDirTree
    % Copy preserving directory structure
    copyfiles(deps(tt), target_folder, ttbasepath);
else
    % Create private subdirectory
    if ~exists('private'); mkdir('private'); end
    
    % Keep only tt deps
    tt_deps = deps(tt);
    
    % Check for duplicate filenames and issue warning
    [filenames,counts] = count_unique(get_filename(tt_deps));
    if numel(filenames) < sum(counts)
        isDupe = counts > 1;
        warning('The following dependencies have duplicate filenames:\n%s', ...
            ['  ' strjoin(deps(contains(tt_deps, filenames(isDupe))),'\n  ')])
    end
    
    % Copy each dependency
    for i = 1:numel(tt_deps)
        try
            copyfile(tt_deps{i},'private')
        catch
            warning('Could not copy: %s', tt_deps{i})
        end
    end
end

end
