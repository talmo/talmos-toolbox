function str = secs2str(num_secs, str_format)
%SECS2STR Converts a number of seconds to a string.
% Usage:
%   str = secs2str(num_secs)
%   str = secs2str(num_secs, 'approx') % only returns first two units of time
% 
% This is a wrapper for seconds2human().
%
% See also: seconds2human, datestr

% Parse input
if nargin < 2
    str_format = 'full';
else
    if ischar(str_format)
        if instr(str_format, {'approx', 'about', 'short'})
            str_format = 'short';
        elseif instr(str_format, {'exact', 'full', 'long'})
            str_format = 'full';
        end
    elseif islogical(str_format)
        if str_format
            str_format = 'short';
        else
            str_format = 'full';
        end
    else
        error('Invalid string format specified.')
    end
end

% Wrap!
str = seconds2human(num_secs, str_format);

end

