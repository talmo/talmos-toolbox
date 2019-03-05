function [amps, freqs] = compute_cwt(X, varargin)
%COMPUTE_CWT Computes CWT amplitudes from a set of timeseries.
% Usage:
%   [amps, freqs] = compute_cwt(X)
%   [amps, freqs] = compute_cwt(X, ...)
% 
% Args:
%   X: TxD real matrix of D timeseries with T timepoints
%
% Params:
%   parallel: compute different dimensions in parallel (default: true)
%
% Returns:
%   amps: CWT amplitudes
% 
% See also: 

% Parse parameters
defaults = struct();
defaults.parallel = true;
defaults.Fs = 100;
defaults.numPeriods = 25;
defaults.omega0 = 25;
defaults.minFreq = 1;
defaults.maxFreq = 100 / 2;
params = parse_params(varargin, defaults);

% Compute Morlet CWT parameters
minT = 1 / params.maxFreq;
maxT = 1 / params.minFreq;
Ts = minT.*2.^((0:params.numPeriods-1).*log(maxT/minT)/(log(2)*(params.numPeriods-1))); % periods
freqs = fliplr(1./Ts); % center frequencies
dt = 1 / params.Fs; % sampling interval (sec)

% Compute CWT amplitudes for each dimension
stic;
[N,D] = size(X);
amps = cell(1,D);
if params.parallel
    parfor i = 1:D
        amps{i} = fastWavelet_morlet_convolution_parallel(X(:,i), freqs, params.omega0, dt)';
    end
else
    for i = 1:D
        amps{i} = fastWavelet_morlet_convolution_parallel(X(:,i), freqs, params.omega0, dt)';
    end
end
amps = [amps{:}]; % length(X) x (D * numPeriods)


end


function [amp,W] = fastWavelet_morlet_convolution_parallel(x,f,omega0,dt)
%fastWavelet_morlet_convolution_parallel finds the Morlet wavelet transform
%resulting from a time series
%
%   Input variables:
%
%       x -> 1d array of projection values to transform
%       f -> center bands of wavelet frequency channels (Hz)
%       omega0 -> dimensionless Morlet wavelet parameter
%       dt -> sampling time (seconds)
%
%
%   Output variables:
%
%       amp -> wavelet amplitudes (N x (pcaModes*numPeriods) )
%       W -> wavelet coefficients (complex-valued)
%
%
% (C) Gordon J. Berman, 2014
%     Princeton University

    N = length(x);
    L = length(f);
    amp = zeros(L,N);
    if mod(N,2) == 1
        x(end+1) = 0;
        N = N + 1;
        test = true;
    else
        test = false;
    end
    
    
    s = size(x);
    if s(2) == 1
        x = x';
    end
    
    x = [zeros(1,N/2) x zeros(1,N/2)];
    M = N;
    N = length(x);
    
    scales = (omega0 + sqrt(2+omega0^2))./(4*pi.*f);
    Omegavals = 2*pi*(-N/2:N/2-1)./(N*dt);
    
    xHat = fft(x);
    xHat = fftshift(xHat);
    
    if test
        idx = (M/2+1):(M/2+M-1);
    else
        idx = (M/2+1):(M/2+M);
    end
    
    if nargout == 2
        W = zeros(size(amp));
        test2 = true;
    else
        test2 = false;
    end
    
    parfor i=1:L
        
        m = morletConjFT(-Omegavals*scales(i),omega0);
        q  = ifft(m.*xHat)*sqrt(scales(i));
        
        q = q(idx);
        
        amp(i,:) = abs(q)*pi^-.25*exp(.25*(omega0-sqrt(omega0^2+2))^2)/sqrt(2*scales(i));
       
        if test2
            W(i,:) = q;
        end
    end
   
end
function out = morletConjFT(w,omega0)
%morletConjFT is used by fastWavelet_morlet_convolution_parallel to find
%the Morlet wavelet transform resulting from a time series

out = pi^(-1/4).*exp(-.5.*(w-omega0).^2);
end