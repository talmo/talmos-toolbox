function absolutePath = abspath(relPath)
%ABSPATH Resolves the absolute path of relative paths (wrapper for GetFullPath).
% Usage:
%   absolutePath = abspath(relPath)
%
% See also: GetFullPath

if iscellstr(relPath)
    absolutePath = cf(@abspath, relPath);
else
    absolutePath = GetFullPath(relPath);
end

end

