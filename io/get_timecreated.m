function timecreated = get_timecreated(filename, datestr_format)
%GET_TIMECREATED Returns the date that the file was created as a date string.
% Usage:
%   timecreated = get_timecreated(filename)
%   timecreated = get_timecreated(filename, datestr_format)
%
% Notes:
% - On Windows, calls the Windows API via a C-mex function.
% - On Unix, this function attempts to find the time of file birth with the
%   stat -f %W flag, but this value is not set on most filesystems.
%   See: http://unix.stackexchange.com/questions/91197/how-to-find-creation-date-of-file
% - On Mac OS X, the GetFileInfo command is used.
% - If the creation date is unavailable, the last modified date is returned.
% 
% See also: get_timemodified, datestr, GetFileTime

if ~exists(filename)
    error('File does not exist.')
end

if nargin < 2
    datestr_format = 'yyyy-mm-dd HH:MM:SS';
end

try
    if ispc
        % Use MEX file by Jan Simon (from File Exchange -> FileTime)
        timecreated = datestr(GetFileTime(filename, [], 'Creation'), datestr_format);
    elseif ismac
        % Use GetFileInfo to get creation time
        % Returns: 'mm/dd/yyyy HH:MM:SS'
        % Reference: https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/GetFileInfo.1.html
        command = sprintf('GetFileInfo -d "%s"', filename);
        [status, cmdout] = system(command);
        if status ~= 0; error(cmdout); end

        % Parse date
        timecreated = datevec(strtrim(cmdout), 'mm/dd/yyyy HH:MM:SS');
        timecreated = datestr(timecreated, datestr_format);
    elseif isunix
        % Use the stat command to get date
        % Returns: seconds since Epoch (01-01-1970 00:00:00) or 0
        % Reference: http://man7.org/linux/man-pages/man1/stat.1.html
        command = sprintf('stat -f %W "%s"', filename);
        [status, cmdout] = system(command);
        if status ~= 0; error(cmdout); end
        
        % Get seconds since Epoch
        timecreated = str2double(cmdout);
        
        if timecreated == 0; error('Unix file birth time not available.'); end
        
        % Convert from seconds since Epoch to MATLAB datenum
        timecreated = datenum(1970, 1, 1, 0, 0) + timecreated / 86400;
        
        % Parse date
        timecreated = datestr(timecreated, datestr_format);
    else
        error('Unsupported operating system.')
    end
catch
    timecreated = get_timemodified(filename, datestr_format);
    warning('Unable to get the file creation time, returned last modified date.')
end
end

