function filename = get_filename(path, no_ext)
%GET_FILENAME Returns the filename in a path. The path need not exist.
% Usage:
%   filename = get_filename(path)
%   filename = get_filename(paths) % cell array of paths
%   filename = get_filename(_, true) % no extension
%
% See also: get_ext, fileparts

if nargin < 2
    no_ext = false;
end

if ischar(path) || (isstring(path) && isscalar(path))
    [~, filename, ext] = fileparts(path);
    if ~no_ext
        if ischar(path)
            filename = [filename ext];
        elseif isstring(path)
            filename = strcat(filename, ext);
        end
    end
elseif iscellstr(path)
    filename = cellfun(@(p) get_filename(p, no_ext), path, 'UniformOutput', false);
elseif isstring(path) && ~isscalar(path)
    filename = arrayfun(@(p) get_filename(p, no_ext), path);
end

end

