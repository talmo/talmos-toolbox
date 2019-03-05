function varargout = javapaths(varargin)
%JAVAPATHS Edits or manages the static Java class paths file.
% Usage:
%   javapaths            % returns contents of the file as cell array of paths
%   javapaths('-lines')  % alias
%   javapaths('-edit')   % opens the file for editing
%   javapaths('-path')   % returns path
%   javapaths(pathToJAR) % appends path to file if it is not already there
%   javapaths('-add', pathToJAR) % alias
%   javapaths('-remove', pathToJAR) % removes path to file if it exists
% 
% See also: javaclasspath, javaaddpath

% Figure out command mode
cmd = '-lines';
if nargin > 0; cmd = varargin{1}; end

% Find path
staticPathsFile = ff(prefdir,'javaclasspath.txt');
if ~exists(staticPathsFile)
    initFile();
    printf('Java class path file created: %s\nCall <a href="matlab:javapaths(''-edit'')">javapaths(''-edit'')</a> to edit.', staticPathsFile)
end

% Execute command
switch cmd
    case '-lines'
        lines = getContents();
        if nargout > 0
            varargout{1} = lines;
        else
            disp(strjoin(lines,'\n'))
        end
    case '-edit'
        edit(staticPathsFile)
    case '-path'
        varargout{1} = staticPathsFile;
    case '-add'
        if nargin == 1; error('Specify path to JAR file to add to Java class path.'); end
        addPath(strjoin(varargin(2:end),' '))
    case {'-rm','-remove'}
        if nargin == 1; error('Specify path to JAR file to add to Java class path.'); end
        rmPath(strjoin(varargin(2:end),' '))
    otherwise
        addPath(strjoin(varargin,' '))
end



    function initFile()
    % Initialize empty file
        if ~exists(staticPathsFile)
            writestr(staticPathsFile,'');
        end
    end

    function lines = getContents()
    % Get contents
        
        % Read and split
        lines = strsplit(strtrim(fileread(staticPathsFile)),'\n');
    end

    function addPath(path)
    % Adds specified jar path to Java class path file
        
        % Check filename
        if ~endsWith(path,'.jar','IgnoreCase',true); error('Path to be added must be a JAR file.'); end
        
        % Resolve path and check if the file exists
        path = abspath(path);
        if ~exists(path); error('Specified path does not exist: %s', path); end
        
        % Check if it already exists and append if new
        currentPaths = getContents();
        if ~any(contains(currentPaths,path))
            currentPaths{end + 1} = path;
            writestr(staticPathsFile,strtrim(strjoin(currentPaths,'\n')))
            printf('Added to static Java class paths: %s', path)
        end
    end

    function rmPath(path)
    % Removes specified jar path to Java class path file
        
        % Check if it already exists and remove if exists
        currentPaths = getContents();
        isPath = contains(currentPaths,path);
        if any(isPath)
            currentPaths = currentPaths(~isPath);
            writestr(staticPathsFile,strtrim(strjoin(currentPaths,'\n')))
            printf('Removed from static Java class paths: %s', path)
        else
            warning('Path not found in static Java class path: %s', path)
        end
    end

end
