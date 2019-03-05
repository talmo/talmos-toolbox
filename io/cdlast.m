function cdlast(offset)
%CDLAST Change into the last modified directory.
% Usage:
%   cdlast
%   cdlast(offset)
% 
% See also: GetFileTime

if nargin < 1; offset = 0; end

folders = dir_folders(pwd);
if isempty(folders); return; end

write_times = cellfun(@(x)GetFileTime(x,'native','Write'),folders);
idx = argsort(write_times,'descend');

if offset >=0
    i = idx(1+offset);
else
    i = idx(end+offset);
end

cd(folders{i})

end
