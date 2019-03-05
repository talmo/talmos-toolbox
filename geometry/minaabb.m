function [Vx, Vy] = minaabb(Px, Py)
%MINAABB Computes the vertices of the minimum axis-aligned bounding box (AABB) of a set of points.
% The vertices of the minimum AABB form the smallest area rectangle that
% contain the points in P, with edges parallel to the X and Y axes.
%
% Usage:
%   V = minaabb(P)
%   V = minaabb(Px, Py)
%   [Vx, Vy] = minaabb(...)
%
% Args:
%   P: matrix of points
%   Px, Py: vectors of point components
%
% Returns:
%   V: matrix (5x2) of the vertices of the minimum AABB
%   Vx, Vy: component vectors (5x1) of the vertices of the minimum AABB
%
% Notes:
%   - The points in V form a CLOSED polygonal chain, i.e.:
%       V(1, :) == V(2, :)
%   - The points are are specified counter-clockwise starting at the
%     bottom-left vertex.
%   - This is also referred to as the "minimum bounding rectangle" (MBR).
%   - This is NOT guaranteed to be the "minimum bounding box" or 
%     "smallest-area enclosing rectangle" for the set of points!
%     There may be an "oriented minimum bounding box" (OMBB), a rectangle
%     that is rotated with respect to the axes, which may have a smaller
%     area. See the rotating calipers algorithm for computing the OMBB.
%
% Resources:
%   - http://www.datagenetics.com/blog/march12014/index.html
%   - http://geidav.wordpress.com/2014/01/23/computing-oriented-minimum-bounding-boxes-in-2d/
%   - http://en.wikipedia.org/wiki/Minimum_bounding_box
%   - http://www.mathworks.com/matlabcentral/fileexchange/34767-a-suite-of-minimal-bounding-objects
%
% See also: sz2bb, sec_bb, ref_bb, minboundrect, minboundrect

% Validate the points
if nargin < 2
    [Px, Py] = validatepoints(Px);
else
    [Px, Py] = validatepoints(Px, Py);
end

% Calculate the boundaries of the points
min_x = min(Px); min_y = min(Py);
max_x = max(Px); max_y = max(Py);

% Build the closed polygonal chain of the minimum AABB counter-clockwise
V = [min_x, min_y;  % bottom-left
     max_x, min_y;  % bottom-right
     max_x, max_y;  % top-right
     min_x, max_y;  % top-left
     min_x, min_y]; % bottom-left (first vertex => closes the chain)

% Return the vertices
if nargout < 2
    Vx = V;
    Vy = [];
else
    Vx = V(:, 1);
    Vy = V(:, 2);
end
end

