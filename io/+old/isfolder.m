function TF = isfolder(path)
%ISFOLDER Returns true if the path exists and is a folder.
% Usage:
%   TF = isfolder(path)
%   TF = isfolder(paths) % cell array of paths
%
% Note: This does the same as isdir, but also accepts cell arrays.
%
% See also: isfile, isdir, is*, exist

if ischar(path)
    TF = exist(path, 'dir') == 7; % 2 = file, 7 = folder
elseif iscellstr(path)
    TF = cellfun(@isfolder, path);
end
end
