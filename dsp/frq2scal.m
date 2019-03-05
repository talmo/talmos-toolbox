function scales = frq2scal(freqs, wname, Fs)
%FRQ2SCAL Converts frequencies to scales for the given wavelet function.
% Args:
%   freqs: vector of frequencies in Hz
%   wname: name of the wavelet function (ex: 'haar', 'morl')
%   Fs: the sampling frequency in Hz (default = 1)
%
% Usage:
%   scales = frq2scal(freqs, wname)
%   scales = frq2scal(freqs, wname, Fs)
%
% Example:
% >> sum(freqs - scal2frq(frq2scal(freqs, 'morl', Fs), 'morl', 1/Fs))
% 
% ans =
% 
%    1.9984e-14
%
% See also: scal2frq, centfrq

if nargin < 3
    Fs = 1;
end

scales = centfrq(wname) ./ freqs .* Fs;

end

