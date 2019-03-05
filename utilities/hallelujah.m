function hallelujah(t)
%HALLELUJAH Description
% Usage:
%   hallelujah
%   hallelujah(t)
% 
% Args:
%   t: number of seconds to play (default: 2)
% 
% See also: 

if nargin < 1; t = 2; end

load('handel')
sound(y(1:round(Fs*t)), Fs)

end
