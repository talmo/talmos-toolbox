function sc = coefs2sc(coefs)
%COEFS2SC Computes the scalogram from CWT coefficients.
% Usage:
%   sc = coefs2sc(coefs)
%
% Args:
%   coefs: coefficients matrix from the cwt function
%
% Returns:
%   sc: scalogram matrix of the same size as coefs where the values
%       represent the percentage of energy of each coefficient
%
% See also: wscalogram, cwt

S = abs(coefs.*coefs);
sc = 100*S./sum(S(:));

end

