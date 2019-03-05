function [amplitude, freq] = ezfft(signal, Fs, dim)
%EZFFT Simple FFT. Returns single-sided absolute amplitudes.
% Usage:
%   [power, freq] = ezfft(signal, Fs)
%   [power, freq] = ezfft(signal, Fs, dim)

if nargin < 2
    Fs = 1;
end
if nargin < 3
    dim = 1;
end

m = length(signal);     % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(signal, n, dim);     % DFT


P2 = abs(y / n);
P1 = P2(1:(n/2 + 1));
P1(2:end-1) = 2*P1(2:end-1);

freq = 0:(Fs/n):(Fs/2-Fs/n);
amplitude = P1(1:n/2);

end

