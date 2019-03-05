function created_dir = mkdirp(path)
%MKDIRP Creates directories (including intermediates) if path does not exist. This is intended to mimic mkdir -p functionality.
% Usage:
%   mkdirp(path)
%   created_dir = mkdirp(path)
% 
% Args:
%   path: path to directory to create
%   
% Returns:
%   created_dir: returns true if directories were created
% 
% See also: mkdir, mkdirto

warning('off','MATLAB:MKDIR:DirectoryExists')
created_dir = mkdir(path);
warning('on','MATLAB:MKDIR:DirectoryExists')

if nargout < 1; clear created_dir; end

end
