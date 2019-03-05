function I = intersect_polys(P, Q)
%INTERSECT_POLYS Finds the intersection between two convex polygons, P and Q.
% Usage:
%   I = intersect_polys(P, Q)
%
% Args:
%   P, Q: convex polygons
%
% Returns:
%   I: polygon of the intersection, or empty if they do not intersect
%
% Notes:
%   - This is a naive brute force intersection algorithm for a pair of 
%     convex polygons.
%   - This will only return a closed convex intersection, meaning, if there
%     are two or more disjoint areas of intersection, their convex hull
%     will be returned.
%   - For a more sophisticated solution, see: the Sutherland–Hodgman, 
%     Weiler–Atherton, Greiner-Hormann or Vatti clipping algorithms.
%
% Algorithm:
%   1. Check if bounding boxes for P and Q intersect. This avoids
%      unnecessary computation if they are definitely not intersecting.
%   2. Compute the simplified convex hull of P and Q. This reduces the
%      number of line segments to check.
%   3. For every pair of line segments, (p, q), p ? P, q ? Q, check if p
%      and q intersect. If they do, store the point(s) of intersection.
%   4. Check if the vertices of P are in Q and vice-versa. Store all the
%      vertices that intersect.
%   5. If there are at least 3 stored points, compute the simplified convex
%      hull of the points. This is the intersection.
%
% See also: intersect_poly_sets, bb_hittest, intersect_line_segs

% Initial set of 
I = [];

% Do a fast first-order approximation: if their bounding boxes do not
% overlap, then there will be no intersection
if ~bb_hittest(P, Q)
    return
end

% Make sure P and Q are convex hulls
P = P(convhull(double(P), 'simplify', true), :);
Q = Q(convhull(double(Q), 'simplify', true), :);

% Find intersections between every pair of edges in P and Q
for i = 1:size(P, 1) - 1
    Pi = [P(i, :); P(i + 1, :)]; % edge i in P
    for j = 1:size(Q, 1) - 1
        Qj = [Q(j, :); Q(j + 1, :)]; % edge j in Q
        
        % Find intersections between these edges
        I = [I; intersect_line_segs(Pi, Qj)];
    end
end

% Find intersecting vertices
PinQ = inpolygon(P(:, 1), P(:, 2), Q(:, 1), Q(:, 2));
QinP = inpolygon(Q(:, 1), Q(:, 2), P(:, 1), P(:, 2));
I = [I; P(PinQ, :); Q(QinP, :)];

% Check if we have enough points to form an intersection
if size(I, 1) < 3
    I = [];
    return
end

% Format as convex hull of all intersecting points
I = I(convhull(double(I), 'simplify', true), :);
end

