function [ellipses, gmm] = fitellipsegmm(BW, N, confidence, varargin)
%FITELLIPSEGMM Fits ellipses in a binary image using a GMM.
% Usage:
%   ellipses = fitellipsegmm(BW)
%   ellipses = fitellipsegmm(BW, N, confidence)
%   ellipses = fitellipsegmm(BW, N, confidence, ...)
%   [ellipses, gmm] = fitellipsegmm(_)
%
% Args:
%   BW: binary (logical) image
%   N: number of components (ellipses) (default: 1)
%   confidence: confidence interval to use for ellipse bounds (default: 0.90)
%   Also accepts any parameters that fitgmdist takes.
%
% Returns:
%   ellipses: N x 5 matrix of the form [x y a b theta_degrees]
%   gmm: GMModel instance with the model parameters
%
% Example:
%   ellipses = fitellipsegmm(BW, 2, 0.9, 'Replicates', 5, 'Start', 'plus')
%
% See also: fitgmdist

if nargin < 2 || isempty(N); N = 1; end
if nargin < 3 || isempty(confidence); confidence = 0.90; end

% Turn off spammy warnings
warning('off','stats:gmdistribution:FailedToConverge')
warning('off','stats:gmdistribution:FailedToConvergeReps')

% Convert mask to points
if size(BW,2) == 2 && ~islogical(BW)
    pts = BW;
else
    pts = mask2pts(BW>0);
end

% Fit
gmm = fitgmdist(pts, N, varargin{:});

% Compute ellipse parameters
ellipses = zeros(N, 5);
for i = 1:N
    % Centroid
    xy = gmm.mu(i,:); % [xi, yi]
    
    % Compute confidence interval to get remaining ellipse parameters
    covariance = gmm.Sigma(:,:,i);
    [eigvecs, eigvals] = eig(covariance);
    
    % Compute chi-squared critical value
    chi_crit = chi2inv(confidence, 2); % df = 2 since we're in R^2
    
    % Find major axis
    [max_val, max_idx] = max(diag(eigvals));
    a = sqrt(chi_crit * max_val);
    
    % Find minor axis
    min_val = min(diag(eigvals));
    b = sqrt(chi_crit * min_val);
    
    % Find angle
    max_vec = eigvecs(:,max_idx);
    theta = atan2(max_vec(2), max_vec(1));
    if (theta < 0); theta = theta + 2*pi; end
    
    % Save
    ellipses(i,:) = [xy a b rad2deg(theta)];
end

% Turn spammy warnings back on
warning('on','stats:gmdistribution:FailedToConverge')
warning('on','stats:gmdistribution:FailedToConvergeReps')

end

