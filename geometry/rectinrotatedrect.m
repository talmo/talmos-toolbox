function inner_rect = rectinrotatedrect(w, h, theta)
%RECTINROTATEDRECT Returns the axis-aligned rectangle with the maximum area that is inscribed in another, rotated rectangle.
% Usage:
%   inner_rect = rectinrotatedrect(w, h, theta)
%
% Reference:
%   http://stackoverflow.com/questions/16702966/rotate-image-and-crop-out-black-borders/16778797#16778797
%   http://stackoverflow.com/questions/5789239/calculate-largest-rectangle-in-a-rotated-rectangle#7519376

long_side = max(w, h);
short_side = min(w, h);

% since the solutions for angle, -angle and 180-angle are all the same, it
% suffices to look at the first quadrant and the absolute values of sin,cos
sin_a = abs(sind(theta));
cos_a = abs(cosd(theta));

if mod(theta, 90) == 0
    wr = w;
    hr = h;
elseif mod(theta, 45) == 0
    wr = w / sqrt(2);
    hr = h / sqrt(2);
elseif short_side <= 2 * sin_a * cos_a * long_side
    % half constrained case: two crop corners touch the longer side, the 
    % other two corners are on the mid-line parallel to the longer line
    x = 0.5 * short_side;
    if w >= h
        wr = x / sin_a;
        hr = x / cos_a;
    else
        wr = x / cos_a;
        hr = x / sin_a;
    end
else
    % fully constrained case: crop touches all 4 sides
    cos_2a = cos_a * cos_a - sin_a * sin_a;
    wr = (w * cos_a - h * sin_a) / cos_2a;
    hr = (h * cos_a - w * sin_a) / cos_2a;
end

% theta = counterclockwise
theta = -theta;
alpha = theta + 90;

quadrant = ceil(mod(theta, 360) / 90) + ~mod(theta, 90);
switch quadrant
    case 1
        r = sind(mod(theta, 90)) * wr;
        v1 = [cosd(alpha), sind(alpha)] * r;
        v2 = v1 + [wr 0];
        v3 = v1 + [0 hr];
        v4 = v1 + [wr hr];
    case 2
        r = sind(mod(theta, 90)) * hr;
        v1 = [cosd(alpha), sind(alpha)] * r;
        v2 = v1 + [-wr 0];
        v3 = v1 + [0 hr];
        v4 = v1 + [-wr hr];
    case 3
        r = sind(mod(theta, 90)) * wr;
        v1 = [cosd(alpha), sind(alpha)] * r;
        v2 = v1 + [-wr 0];
        v3 = v1 + [0 -hr];
        v4 = v1 + [-wr -hr];
    case 4
        r = sind(mod(theta, 90)) * hr;
        v1 = [cosd(alpha), sind(alpha)] * r;
        v2 = v1 + [wr 0];
        v3 = v1 + [0 -hr];
        v4 = v1 + [wr -hr];
end
inner_rect = minaabb([v1; v2; v3; v4]);

end

