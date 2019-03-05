function saveText(filePath, strings, delim)
%SAVETEXT Saves a cell array of strings to a text file.
% Usage:
%   saveText(filePath, strings) % default delim = '\n'
%   saveText(filePath, strings, delim)

if nargin < 3
    delim = '\n';
end

f = fopen(filePath, 'w');
if iscell(strings)
    strings = strjoin(strings, delim);
end

fprintf(f, '%s', strings);

fclose(f);

end

