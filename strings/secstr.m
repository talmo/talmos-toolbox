function secondsStr = secstr(seconds, formatOut)
%SECSTR Format a number of seconds as a string.
% This function is a wrapper for datestr.
%
% Args:
%   seconds = number of seconds
%   formatOut = the output string format (default = 'HH:MM:SS.FFF'). See
%       the documentation for datestr() for more info.
%
% Usage:
%   secondsStr = secstr(seconds)
%   secondsStr = secstr(seconds, formatOut)
%
% See also: datestr

% Default
if nargin < 2
    formatOut = 'HH:MM:SS.FFF';
end

% Convert seconds to days for datestr
days = seconds / (60 * 60 * 24);

% Format as string
secondsStr = datestr(days, formatOut);

end

