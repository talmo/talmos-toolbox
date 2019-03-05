function freqs = dyadFreqs(minF, maxF, numSamples)
%DYADFREQS Samples a range of frequencies with dyadic spacing.
% Args:
%   minF: minimum frequency
%   maxF: maximum frequency
%   numSamples: number of frequencies to return
% 
% Usage:
%   freqs = dyadFreqs(minF, maxF, numSamples)

minT = 1/minF;
maxT = 1/maxF;
Ts = minT .* 2.^ ((0:numSamples-1) .* log(maxT/minT) / (log(2)*(numSamples-1)));
freqs = 1./Ts;

end

