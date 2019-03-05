function angles = points_angle(ptsA, ptsB)
%POINTS_ANGLE Calculates the angle between the two vectors of points relative to the origin.

angles = cell2mat(cellfun(@(u,v) atan2d(u(1) * v(2) - v(1) * u(2), u(1) * v(1) + u(2) * v(2)), num2cell(ptsA, 2), num2cell(ptsB, 2), 'UniformOutput', false));
end

