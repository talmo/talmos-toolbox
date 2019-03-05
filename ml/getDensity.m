function [density, X, X_d] = getDensity(points, sigma, numGridPoints, gridRange)
%GETDENSITY Convolves a point cloud with a Gaussian kernel to estimate the density.
% Usage:
%   density = getDensity(points)
%   density = getDensity(points, sigma, numGridPoints, gridRange)
%   [density, X, X_d] = getDensity(...)
%
% Args:
%   points:
%       N X 2 array of points
%   sigma:
%       Sigma parameter for Gaussian kernel (default = max(abs(points(:))) / 30)
%   numGridPoints:
%       Number of points to evaluate on grid (default = 500)
%   gridRange:
%       gridRange = [-maxVal * 1.1, maxVal * 1.1]
%
% Returns:
%   density:
%       numGridPoints X numGridPoints array containing the PDF values
%   X:
%       N X 2 array of the coordinates of the original points in the space
%   X_d:
%       N x 1 vector of the densities of the original points
% 
% Example:
%   [density, X, X_d] = getDensity(mappedX);
% 
%   % Density space:
%   figure; imagesc(density); axis xy
%   figure; contour(density)
% 
%   % Original points colored by density
%   figure; scatter(mappedX(:,1), mappedX(:,2), 3, X_d) 
% 
% See also: tsne, imagesc, contour, scatter

maxVal = max(abs(points(:)));
if nargin < 2 || isempty(sigma)
    sigma = maxVal / 30;
end
if nargin < 3 || isempty(numGridPoints)
    numGridPoints = 500;
end
if nargin < 4 || isempty(gridRange)
    gridRange = [-maxVal * 1.1, maxVal * 1.1];
end

% Generate a grid which will be used to evaluate the points on
xx = linspace(gridRange(1), gridRange(2), numGridPoints);
yy = xx;
[XX,YY] = meshgrid(xx,yy);

% Create the Gaussian kernel to convolve with
G = exp(-.5.*(XX.^2 + YY.^2)./sigma^2) ./ (2*pi*sigma^2);

% Compute 2-D histogram of the points evaluated on the grid and normalize
Z = hist3(points, {xx,yy})';
Z = Z ./ (sum(Z(:)));

% Convolve histogram with histogram
density = conv2(Z, G, 'same');

% Evaluate each point in density space
X = [interp1(xx, 1:numGridPoints, points(:,1)) interp1(yy, 1:numGridPoints, points(:,2))];
X_d = interp2(density, X(:,1), X(:,2));

return
%% Visualizations
% Contour plot of density
figure
contour(density)
% Overlay points
hold on; plot(X(:,1), X(:,2), 'r.')

% Heatmap of density
figure
imagesc(gridRange, gridRange, density)
axis xy

% Points colored by density value
figure
scatter(X(:,1), X(:,2), 3, X_d, 'filled')

end

