function M = geomedian(X, Y, tol)
%GEOMEDIAN Computes the geometric median for a set of points.
% Usage:
%   geomedian(X, Y)
%   geomedian(XY)
%
% Args:
%   X and Y must be vectors of X and Y coordinates.
%   XY can be a 2xM of XY coordinates.
%   tol is the tolerance for the Simulated Annealing algorithm, default is
%       set to eps.
%
% Ref:
%   http://en.wikipedia.org/wiki/Geometric_median

% Split XY matrix into X and Y vectors
if nargin < 2
    Y = X(:, 2);
    X = X(:, 1);
end

if nargin < 3
    tol = eps;
end

% Make sure X and Y are column vectors
X = X(:);
Y = Y(:);

% Objective function = total Euclidean distance
obj = @(X, Y, Mx, My) sum(sqrt(sum([X - Mx, Y - My] .^ 2, 2)));

% Initialize the geometric median to the mean of the points
Mx = mean(X);
My = mean(Y);

% Initialize step
step = 100;

% Initialize total distance
d = obj(X, Y, Mx, My);

% Neighbors
Nx = [0  0 -1 1]';
Ny = [1 -1  0 0]';

while step > tol
    for i = 1:4
        Mx2 = Mx + step * Nx(i);
        My2 = My + step * Ny(i);
        d2 = obj(X, Y, Mx2, My2);
        if d2 < d
            break
        end
    end
    
    % Half the step size if we didn't update
    if d2 < d
        d = d2;
        Mx = Mx2;
        My = My2;
    else
        step = step / 2;
    end
end

% Output
M = [Mx, My];

end

