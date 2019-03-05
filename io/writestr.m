function writestr(filename,str)
%WRITESTR Write a string to a file. Plain and simple!
% Usage:
%   writestr(filename, str)
%   writestr(filename, cellstr)
%
% See also: saveText

if iscellstr(str)
    str = strjoin(str,'\n');
end

f = fopen(filename, 'w');
fprintf(f, '%s', str);
fclose(f);


end

