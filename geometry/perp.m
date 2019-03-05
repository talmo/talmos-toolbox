function V_perp = perp(V)
%PERP Returns the perpendicular vector to V in 2-D. V_perp is rotated 90 degrees CCW from V.
% Formula: V_perp = (-Vy, Vx)
% Reference:
%   http://geomalgorithms.com/vector_products.html
%   http://mathworld.wolfram.com/PerpendicularVector.html

V_perp = reshape([-V(2), V(1)], size(V));

end

