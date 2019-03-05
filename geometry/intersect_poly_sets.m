function [I, idx] = intersect_poly_sets(A, B)
%INTERSECT_POLY_SETS Takes two sets of polygons and finds intersections between them.
% Usage:
%   I = intersect_poly_sets(A, B)
%   [I, idx] = intersect_poly_sets(A, B)
%   ... = intersect_poly_sets(A) % self-intersection
%
% Args:
%   A and B must be cell arrays, or cell array and matrix, of Mx2 polygons
%       If B is omitted, self-intersection is returned
%
% Returns:
%   I: Nx1 cell array of the the polygons of the N intersections
%   idx: [length(A), length(B)] cell array where the idx{i,j} contains
%       the indices to the intersects in I between A{i} and B{j}, if any.

% Process inputs
if nargin < 2
    B = A;
    self_intersect = true;
else
    self_intersect = false;
end
if ~iscell(A); A = {A}; end
if ~iscell(B); B = {B}; end

% Initialize containers
I = {};
idx = cell(length(A), length(B));

% Loop each combination of the polygon sets
for a = 1:length(A)
    b_start = 1;
    if self_intersect; b_start = a; end
    for b = b_start:length(B)
        % If we're self-intersecting, skip self-to-self
        if a == b && self_intersect
            continue
        end
        
        % Try intersecting the pair
        Iab = intersect_polys(A{a}, B{b});
        
        if ~isempty(Iab)
            % Save intersecting region
            I{end + 1} = Iab;
            idx{a, b}(end + 1) = length(I);
            if self_intersect; idx{b, a}(end + 1) = length(I); end
        end
    end
end

% Return vertical vector
I = I';
end

