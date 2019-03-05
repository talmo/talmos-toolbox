function S = nowstr(format)
%NOWSTR Returns current date or time as a string.
% Usage:
%   S = nowstr
%   S = nowstr(format)
%
% Args:
%   format: datestr format (default: 'yymmdd_HHMM')
%
% Returns:
%   S: formatted string
% 
% See also: datestr, isodate

if nargin < 1; format = 'yymmdd_HHMMSS'; end

S = datestr(now, format);

end
