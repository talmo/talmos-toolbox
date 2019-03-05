function bb = rect2bb(xmin, ymin, width, height)
%RECT2BB Takes the parameters of a rectangle and returns a bounding box polygon.
% Usage:
%   bb = rect2bb(rect)      
%   bb = rect2bb(point, sz)
%   bb = rect2bb(xmin, ymin, sz)
%   bb = rect2bb(xmin, ymin, width, height)
%
% Args:
%   Expected formats:
%       rect = [xmin, ymin, width, height]
%       pt = [x, y]
%       sz = [width, height], or scalar if square

narginchk(1, 4)
switch nargin
    case 1
        rect = xmin;
    case 2
        if length(ymin) == 1
            ymin = [ymin, ymin];
        end
        rect = [xmin(1), xmin(2), ymin(1), ymin(2)];
    case 3
        if length(width) == 1
            width = [width, width];
        end
        rect = [xmin, ymin, width(1), width(2)];
    case 4
        rect = [xmin, ymin, width, height];
end

P1 = rect(1:2);
P2 = rect(1:2) + [rect(3) 0];
P3 = rect(1:2) + [0 rect(4)];
P4 = rect(1:2) + [rect(3) rect(4)];

bb = minaabb([P1; P2; P3; P4]);

end

