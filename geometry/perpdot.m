function c = perpdot(A, B)
%PERPDOT Returns the perp dot product of A and B.
% Formula: c = dot(perp(A), B)
%
% Notes:
%   - When c = 0, A and B are both perpendicular to the same vector.
%       => This implies A and B are either collinear.
%   - This is the same as cross2(A, B), but slightly slower.
%
% Reference:
%   http://geomalgorithms.com/vector_products.html
%   http://mathworld.wolfram.com/PerpDotProduct.html
%
% See also: cross2, perp

c = dot(perp(A), B);

end

