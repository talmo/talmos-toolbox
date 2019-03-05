function angles = points_self_angle(ptsA, ptsB)
%POINTS_SELF_ANGLE Calculates the angle between the two vectors of points relative to each other.

u = [1 0];
angles = cell2mat(cellfun(@(v) atan2d(u(1) * v(2) - v(1) * u(2), u(1) * v(1) + u(2) * v(2)), num2cell(ptsB - ptsA, 2), 'UniformOutput', false));

end

