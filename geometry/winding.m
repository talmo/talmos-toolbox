function w = winding(points, vertices)
%WINDING Calculates the winding number of the points.
% Args:
%   points is a Mx2 matrix of points
%   vertices is a matrix specifying the vertices of the polygon
%
% Returns:
%   w is a Nx1 vector where w(n) is the winding number of the N-th point.
%       If the point is not in the polygon, its winding number is 0.
%       If the point is in the polygon, the winding number is 1 if the
%       vertices are specified CCW, or -1 if they are CW.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      Copyright (C) Mike Brookes 2009
%      Version: $Id: polygonwind.m,v 1.1 2009/04/08 07:39:11 dmb Exp $
%
%   VOICEBOX is a MATLAB toolbox for speech processing.
%   Home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You can obtain a copy of the GNU General Public License from
%   http://www.gnu.org/copyleft/gpl.html or by writing to
%   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = size(vertices, 1);
m = size(points, 1);

q = zeros(2, n + 1);
q(:, 1:n) = vertices';
q(:, n + 1) = q(:, 1);

i = 1:n;
j = 2:n + 1;

ym = repmat(2, m, 1);
yn = repmat(2, 1, n);

w = abs(sum((2 * ((repmat(q(1, i) .* q(2, j) - q(2, i) .* q(1, j), m, 1) + points(:, 1) * (q(2,i) - q(2, j)) + points(:, 2) * (q(1, j) - q(1, i))) > 0) - 1) .* abs((q(ym, j) > points(:, yn)) - (q(ym, i) > points(:, yn))), 2) / 2);
end