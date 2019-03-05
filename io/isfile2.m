function TF = isfile2(path)
%ISFILE2 Returns true if the path exists and is a file (and not a folder).
% Usage:
%   TF = isfile2(path)
%   TF = isfile2(paths) % cell array of paths
%
% See also: isdir, is*, exist

if ischar(path)
    TF = ismember(exist(path, 'file'), [2 3]); % 2 = file, 3 = mex, 7 = folder
elseif iscellstr(path)
    TF = cellfun(@isfile2, path);
end
end
