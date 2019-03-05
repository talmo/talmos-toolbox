function [L, h] = seghmaxdist(BW, N, varargin)
%SEGHMAXDIST Applies H-max -> watershed until there are N connected components in BW.
% Usage:
%   L = seghmaxdist(BW, N)
%   L = seghmaxdist(D, N)
%   L = seghmaxdist(BW, N, ...) % params
%   [L, h] = seghmaxdist(_)
% 
% Args:
%   BW: mask with < N connected components
%   D: distance matrix (e.g., bwdist(~BW))
%   N: number of connected components in output
% 
% Params:
%   'Hmin': minimum H-value (default: min(D(BW)))
%   'Hmax', maximum H-value (default: max(D(BW)))
%   'MaxEval': maximum function evaluations (default: 10)
%   'Display': verbosity for fminbnd ('iter','final','off'; default: 'off')
%   'lambda': L1-regularization weight (default: 1.0)
%             Higher values of lambda promote a smaller H parameter
% 
% Returns:
%   L: segmented labels matrix
%   h: optimal threshold parameter for H-max transform
% 
% See also: imhmax, bwdist, watershed, fminbnd, optimset

% Convert to BW if we got an integer
if isinteger(BW)
    BW = logical(BW);
end

% Check if we need to compute distance matrix
if islogical(BW)
    D = bwdist(~BW);
else
    D = BW;
    BW = D > 0;
end

% Params
defaults = {
    'Hmin', min(D(BW))
    'Hmax', max(D(BW))
    'MaxEval', 10
    'Display','off'
    'lambda', 1.0
    }';
params = parse_params(varargin,defaults);

% Segmentation function
BW = uint8(BW);
f = @(h) watershed(-imhmax(D,h)) .* BW;

% Optimize H-max transform
obj = @(h) abs(double(max(max(f(h)))) - N) + (params.lambda * abs(h));
h = fminbnd(obj, double(params.Hmin), double(params.Hmax), ...
    optimset('MaxFunEval',params.MaxEval,'Display',params.Display));

% Apply segmentation
L = f(h);

end
