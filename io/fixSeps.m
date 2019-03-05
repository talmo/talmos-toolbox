function fixedPath = fixSeps(path, targetOS)
%FIXSEPS Fixes the separators for a file path (not including drive).
% Usage:
%   fixedPath = fixSeps(path)
%   fixedPath = fixSeps(path, targetOS)
%
% Args:
%   targetOS: 'unix' or 'windows' (default = whatever OS is running)
%
% Returns:
%   fixedPath: the path with the separators replaced

if nargin < 2
    if isunix; targetOS = 'unix'; else targetOS = 'windows'; end
end

if strcmp(targetOS, 'unix')
    fixedPath = strrep(path, '\', '/');
else
    fixedPath = strrep(path, '/', '\');
end

end

