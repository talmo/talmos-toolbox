function [I1, I2] = intersect_line_segs(P1, P2, U1, U2)
%INTERSECT_LINE_SEGS Computes the intersection between the line segments P and U.
%
% Args:
%   P1, P2 are the endpoint coordinates of the line segment P.
%   U1, U2 are the endpoint coordinates of the line segment U.
%   You may also call this function with two arguments of the form:
%       [P1; P2], [U1; U2].
%
% Returns:
%   I1 contains a point of intersection between P and U if they intersect,
%       otherwise it is empty.
%   I2 contains the second endpoint of the line segment [I1, I2] if P and U
%       are collinear and overlap, otherwise it is empty.
%
%   If there are less than 2 outputs, [I1; I2] is returned instead.
%
% Reference:
%   http://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect/565282#565282
%   http://geomalgorithms.com/a05-_intersect-1.html



if nargin == 2
    % Convert from block format to single points
    P_ = P1; U_ = P2;
    P1 = P_(1, :); P2 = P_(2, :);
    U1 = U_(1, :); U2 = U_(2, :);
end

% We define the line segments in parametric form with unit parameters:
%   P1 + r * (P2 - P1), r = [0, 1]
%   U1 + s * (U2 - U1), s = [0, 1]

% To simplify, we define direction vectors as the difference of endpoints:
%   P + r * Pd, r = [0, 1]
%   U + s * Ud, s = [0, 1]
P = P1; Pd = P2 - P1;
U = U1; Ud = U2 - U1;

% We now proceed to check if they are intersecting.

% We first check if their direction vectors are collinear:
PdxUd = cross2(Pd, Ud); % the 2-D cross product is the same as perpdot
if PdxUd == 0
    % => Pd and Ud are perpendicular to the same vector, so they must be
    %   collinear.
    % => This also implies that P and U are either parallel, collinear,
    %   or at least one of them is a single point.
    
    % Are both line segments a single point?
    if all(P1 == P2) && all(U1 == U2)
        % => They are both a single point.
        
        % Are they the same point?
        if all(P == U)
            % P and U are both the same single point
            I1 = P;
            I2 = [];
        else
            % P and U are different single points
            I1 = [];
            I2 = [];
        end
        
    % Is the first line segment a single point?    
    elseif all(P1 == P2)
        % => P is a single point and U is a line segment
        
        if cross2(U - P, Ud) == 0
            % => P is collinear with U
            
            % Solve for P in terms of the parameter of U:
            i = find(Ud ~= 0); % avoid division by zero error for direction vectors with a 0 component
            s_P = (P(i) - U(i)) / Ud(i);
            
            if s_P >= 0 && s_P <= 1
                % => P is within the endpoints of U
                I1 = P;
                I2 = [];
            else
                % => P and U are disjoint
                I1 = [];
                I2 = [];
            end
        else
            % => P is NOT collinear with U, so it is not in U
            I1 = [];
            I2 = [];
        end
        
    % Is the second line segment a single point?
    elseif all(U1 == U2)
        % => P is a line segment and U is a single point
        
        if cross2(U - P, Pd) == 0
            % => U is collinear with P
            
            % Solve for U in terms of the parameter of P:
            i = find(Pd ~= 0); % avoid division by zero error for direction vectors with a 0 component
            r_U = (U(i) - P(i)) / Pd(i);
            
            if r_U >= 0 && r_U <= 1
                % => U is within the endpoints of P
                I1 = U;
                I2 = [];
            else
                % => U and P are disjoint
                I1 = [];
                I2 = [];
            end
        else
            % => P is NOT collinear with U, so it is not in U
            I1 = [];
            I2 = [];
        end
        
    % P and U are both not a single point, but are they collinear?
    elseif cross2(P - U, Pd) == 0 % <=> cross2(U - P, Ud)
        % => The line from P to U is collinear with the direction vector of
        % P, so the line segments must be collinear.
        
        % Now we must check if they are coincident or disjoint:

        % First, solve for the endpoints of U with the equation for P:
        i = find(Pd ~= 0); % avoid division by zero error for direction vectors with a 0 component
        r1 = (U1(i) - P(i)) / Pd(i);
        r2 = (U2(i) - P(i)) / Pd(i);

        % Define the monotonically increasing intervals of the parameter
        % values of the endpoints of each line:
        r_P = [0 1];
        r_U = sort([r1, r2]);

        % Find the intersection of the two intervals:
        r_UinP = [max(r_P(1), r_U(1)), min(r_P(2), r_U(2))];

        if r_UinP(1) > r_UinP(2)
            % => P and U are collinear but disjoint
            I1 = [];
            I2 = [];
        elseif r_UinP(1) == r_UinP(2)
            % => P and U are collinear and intersect at an endpoint
            I1 = P + r_UinP(1) * Pd;
            I2 = [];
        else
            % => P and U are collinear and overlapping
            I1 = P + r_UinP(1) * Pd;
            I2 = P + r_UinP(2) * Pd;
        end
    else
        % => The lines are just parallel, so they do not intersect
        I1 = [];
        I2 = [];
    end
else
    % => The line segments are non-parallel, now we check if they intersect:

    % Find the parameters for the point where the infinite lines intersect:
    r_I = cross2((U - P), Ud) / PdxUd;
    s_I = cross2((U - P), Pd) / PdxUd;

    % Check if both parameters are within their bounds of [0, 1]
    if 0 <= r_I && r_I <= 1 && 0 <= s_I && s_I <= 1
        % The line segments intersect
        I1 = P + r_I * Pd;
        I2 = [];
    else
        % The line segments do not intersect
        I1 = [];
        I2 = [];
    end
end

if nargout < 2
    I1 = [I1; I2];
end
end

