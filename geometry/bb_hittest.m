function intersecting = bb_hittest(A, B, ignore_edge)
%BB_HITTEST Returns true if the minimum axis-aligned bounding box of the set of points are intersecting.
% This can be used as a first-order approximation of whether two polygons
% are intersecting.
%
% Reference: http://stackoverflow.com/a/306332/1939934

if nargin < 3
    ignore_edge = false;
end

% Compute the vertices of the axis-aligned bounding boxes
minA = min(A); maxA = max(A);
minB = min(B); maxB = max(B);

% Check for rectangle intersection
if ignore_edge
    intersecting = minA(1) < maxB(1) & maxA(1) > minB(1) & ...
                   minA(2) < maxB(2) & maxA(2) > minB(2);
else
    intersecting = minA(1) <= maxB(1) & maxA(1) >= minB(1) & ...
                   minA(2) <= maxB(2) & maxA(2) >= minB(2);
end
end

