function mtime = utime2date(utime,zone)
%utime2date - convert unix date-time epoch to matlab date number
%
% Syntax:  mtime = utime2date(utime)
%          mtime = utime2date(utime,zone)
%
% Inputs:
%    utime - unix time epoch (# of seconds elapsed since 1970-01-01T00:00:00Z)
%     zone - desired UTC time zone
%
% Outputs:
%    mtime - utime date-time as a matlab serial date number
%
% Example:
%    utime2date(0) % returns serial date 1970-01-01T00:00:00Z
%    utime2date(9.999999999999974e+08,-3) % returns serial date 2001-09-08T22:46:40-03:00
%    datestr(utime2date(1356048000)) % return '21-Dec-2012'
%
% See also: date2utime, date, now, datestr

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
mtime = (utime+zone) ./ 86400.0 + 719529;
end
%-------------------------------- END CODE --------------------------------