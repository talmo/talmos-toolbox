function utime = date2utime(mtime,zone)
%date2utime - convert matlab serial date to unix epoch
%
% Syntax:  utime = date2utime(mtime)
%          utime = date2utime(mtime,zone)
%
% Inputs:
%    mtime - matlab serial date number (# of days where 1 = January 1, 0000 A.D.)
%     zone - desired UTC time zone
%
% Outputs:
%    utime - mtime date as unix time epoch (# of seconds elapsed since 1970-01-01T00:00:00Z)
%
% Example:
%    date2utime(719529) % returns 0 milliseconds
%    date2utime(719529,+2) % returns 7200 milliseconds (2h)
%
% See also: utime2date, date, now, datestr

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% August 2014; Version: v1; Last revision: 2014-08-20
% Changelog:
%------------------------------- BEGIN CODE -------------------------------
if nargin < 2
    zone = 0;
end
zone = zone*60*60;
utime = (mtime - 719529) .* 86400.0 +zone;
end
%-------------------------------- END CODE --------------------------------