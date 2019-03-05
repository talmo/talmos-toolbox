function limAB = intersect_lims(limA, limB)
%INTERSECT_LIMS Intersects a pair of limits.
% Usage:
%   limAB = intersect_lims(limA, limB)
%
% Returns [] if no intersection.

limAB = [max(limA(1), limB(1)), min(limA(2), limB(2))];

% No intersection
if limAB(1) > limAB(2)
    limAB = [];
end

end

