function plotstd(X)
%PLOTSTD Plots the mean of all series and shades by the standard deviation.
% Usage:
%   plotstd(X)
%
% Args:
%   X: m series x n points

m = mean(X, 1);
s = std(X, [], 1);
boundedline(1:length(m), m, s)

end

