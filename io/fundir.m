function path = fundir()
%FUNDIR Returns the path to the directory containing the calling function.
% Usage:
%   path = fundir
% 
% See also: funpath

% Get the path to the calling function
path = get_caller_name('path', true);

% Return parent directory
path = fileparts(path);

end
