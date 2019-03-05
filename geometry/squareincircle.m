function square = squareincircle(radius, center)
%SQUAREINCIRCLE Returns the polygon of a square inscribed in a circle.
% Usage:
%   square = squareincircle(radius)
%   square = squareincircle(radius, center)

if nargin < 2
    center = [0, 0];
end

center = validatepoints(center);

square = [-radius / sqrt(2), -radius / sqrt(2);  % bottom-left
          -radius / sqrt(2),  radius / sqrt(2);  % top-left
           radius / sqrt(2),  radius / sqrt(2);  % top-right
           radius / sqrt(2), -radius / sqrt(2);  % bottom-right
          -radius / sqrt(2), -radius / sqrt(2)]; % bottom-left
square = bsxadd(square, center);

end

