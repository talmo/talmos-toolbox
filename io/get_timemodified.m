function timemodified = get_timemodified(filename, datestr_format)
%GET_TIMEMODIFIED Returns the date that the file was last modified as a date string.
% Usage:
%   timemodified = get_timemodified(filename)
%   timemodified = get_timemodified(filename, datestr_format)
%
% See: datestr, get_timecreated, GetFileTime

if ~exists(filename)
    error('File does not exist.')
end

if nargin < 2
    datestr_format = 'yyyy-mm-dd HH:MM:SS';
end

% Get last modified date from directory listing
listing = dir(filename);
timemodified = datestr(listing.datenum, datestr_format);

end

