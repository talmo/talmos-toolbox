function N = countlines(filepath)
%COUNTLINES Returns the number of lines in a text file.
% Usage:
%   countlines(filepath)
% 
% Args:
%   filepath: path to a text file 
% 
% See also: fgetl

fid = fopen(filepath);
N = 0;
tline = fgetl(fid);
while ischar(tline)
    tline = fgetl(fid);
    N = N + 1;
end
fclose(fid);

end
