function alias(aliasName, functionName)
%ALIAS Creates a function alias and saves it to this function's directory.
% Usage:
%   alias aliasName functionName
%   alias(aliasName, functionName)
%
% Source: http://stackoverflow.com/a/19180715

% Check if alias exists
if any(exist(aliasName) == [2 3 5 8])
    error('Alias %s already exists.', aliasName)
end

% Get script directory and build path
aliasFolderPath = fileparts(funpath);
aliasPath = fullfile(aliasFolderPath, [aliasName '.m']);

% Check if target is a function or script
isscript = false;
try
    nargin(functionName);
catch %#ok<CTCH>
    isscript = true;
end

% Save
if isscript
    fileID = fopen(aliasPath,'w');
    fprintf(fileID, '%s\n', ['run(', functionName, ')']);
    fclose(fileID);
    printf('Created alias for script *%s*: *%s*', functionName, aliasName)
else
    fileID = fopen(aliasPath,'w');
    fprintf(fileID, '%s\n', ['function varargout = ', aliasName, '(varargin)']);
    fprintf(fileID, '%s\n', 'N = max(nargout,1);');
    fprintf(fileID, '%s\n', ['varargout{1:N} = ', functionName, '(varargin{:});']);
    fprintf(fileID, '%s\n', 'end');
    fclose(fileID);
    printf('Created alias for function *%s*: *%s*', functionName, aliasName)
end
end