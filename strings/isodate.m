function str = isodate(t)
%ISODATE Returns the date as an ISO 8601 string (yyyy-mm-dd).
% Usage:
%   str = isodate
%   str = isodate(t)
%
% See also: datestr, datetime, date, now

if nargin < 1
    t = now;
end

str = datestr(t, 29);

end

