function TF = istt(path)
%ISTT Returns true if the path(s) are in the toolbox.
% Usage:
%   istt(path)
%
% See also: ttbasepath

if ~iscell(path)
    path = {path};
end

TF = cellfun(@(x) isequal(x, 1), strfind(path, ttbasepath));

end

