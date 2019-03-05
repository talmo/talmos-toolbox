function [overlaps, tile_pairs] = calculate_overlaps(tforms, varargin)
%CALCULATE_OVERLAPS Calculates boundaries of the overlapping regions after applying a set of transforms.
% Usage:
%   overlaps = CALCULATE_OVERLAPS(tforms)
%   [overlaps, tile_pairs] = CALCULATE_OVERLAPS(tforms)
%   overlaps = CALCULATE_OVERLAPS(tforms, 'tile_size', [width height])
%
% Returns a cell array of overlapping regions of the form:
%   overlaps = {[x, y, width, height]}
% And which tiles are being overlapped:
%   tile_pairs = {[i, j]}
% Note that the i,j indices are relative to the inputed transforms!

% Parse inputs
if length(tforms) < 2
    error('At least 2 transforms are needed to calculate overlap.')
end
params = parse_inputs(varargin{:});

% The points that define the boundaries of a tile form a polygon
tile = [0, 0;                    % top-left
        0, params.tile_size(2);  % top-right
        params.tile_size;        % bottom-right
        params.tile_size(2), 0]; % bottom-left

% Apply transforms to get the boundary polygons for each tile
tiles = cellfun(@(t) t.transformPointsForward(tile), tforms, 'UniformOutput', false);

% Plot polygons
if params.visualize
    figure
    colors = get(0,'DefaultAxesColorOrder');
    for i = 1:length(tiles)
        X = [tiles{i}(:, 1); tiles{i}(1, 1)];
        Y = [tiles{i}(:, 2); tiles{i}(1, 2)];
        plot(X, Y, '-x', 'Color', colors(rem(i - 1, size(colors, 1)) + 1, :));
        hold on
    end
    set(gca,'YDir','reverse');
    integer_axes();
    hold off
end

% Look for overlap
overlaps = {}; tile_pairs = {};
for i = 1:length(tiles) - 1
    Xi = [tiles{i}(:, 1); tiles{i}(1, 1)];
    Yi = [tiles{i}(:, 2); tiles{i}(1, 2)];
    for j = i + 1:length(tiles)
        Xj = [tiles{j}(:, 1); tiles{j}(1, 1)];
        Yj = [tiles{j}(:, 2); tiles{j}(1, 2)];
        
        % Find the intersection of all the edge lines
        % Implementation of: http://stackoverflow.com/a/565282/1939934
        intersects = {};
        for e_i = 1:4 % loop through edges in tile i
            % Edge in tile i can be defined as the line segment:
            %   p to p + r
            p = [Xi(e_i) Yi(e_i)];
            p2 = [Xi(e_i + 1) Yi(e_i + 1)]; % = p + r
            r = p2 - p;
            
            for e_j = 1:4 % loop through edges in tile j
                % Edge in tile j can be defined as the line segment:
                %   q to q + s
                q = [Xj(e_j) Yj(e_j)];
                q2 = [Xj(e_j + 1) Yj(e_j + 1)]; % = q + s
                s = q2 - q;
                
                % The intersection is at the point where:
                %   p + tr = q + us
                % For a specific t and u.
                
                % Define the 2d cross products as:
                cross2d = @(v, w) v(1) * w(2) - v(2) * w(1);
                
                % Define some intermediate calculation steps
                qmp = q - p;
                pmq = p - q;
                rxs = cross2d(r, s);
                
                % Check for special cases
                if rxs == 0 && cross2d(qmp, r) == 0
                    % The lines are collinear
                    if  (0 <= dot(qmp, r) && dot(qmp, r) <= dot(r, r)) || ...
                        (0 <= dot(pmq, r) && dot(pmq, r) <= dot(r, r))
                        % The lines are overlapping
                    else
                        % The lines are disjoint
                    end
                elseif rxs == 0 && cross2d(qmp, r) ~= 0
                    % The lines are parallel and non-intersecting
                elseif rxs ~= 0
                    t = cross2d(qmp, s / rxs);
                    u = cross2d(qmp, r / rxs);
                    
                    if 0 <= t && t <= 1 && 0 <= u && u <= 1
                        % The lines intersect and meet where:
                        %   p + tr = q + us
                        %assert(abs(sum((p + t * r) - (q + u * s))) < params.tolerance)
                        
                        % Calculate and save point
                        xy = p + t * r;
                        intersects{1, end + 1} = xy;
                    else
                        % The lines are not parallel but do not intersect
                    end
                end
            end
        end
        
        % Convert to matrix
        I = cell2mat(intersects');
        
        % Round to tolerance
        I = round(I * 1 / params.tolerance) * params.tolerance;
        
        % Get rid of duplicates
        I = unique(I, 'rows');
        
        % Combine the tile bounding points
        V = [[Xi Yi]; [Xj Yj]];
        
        % Get rid of duplicates
        V = unique(V, 'rows');
        
        % Test each vertex to see if it's in both tiles
        in_both = (inpolygon(V(:,1), V(:,2), Xi, Yi) | on_edge(V(:,1), V(:,2), Xi, Yi, params.tolerance)) ...
                & (inpolygon(V(:,1), V(:,2), Xj, Yj) | on_edge(V(:,1), V(:,2), Xj, Yj, params.tolerance));
        
        % There is no overlap if there are no common vertices or intersects
        if ~any(in_both) && isempty(I)
            continue
        end
        
        % Calculate the polygon defining the overlapping region
        W = [I; V(in_both, :)];
        k = convhull(double(W));
        P =  W(k, :);
        Px = P(:, 1);
        Py = P(:, 2);

        % Calculate area for the region
        area = polyarea(Px, Py);

        % Skip small overlaps
        if area < prod(params.tile_size) * params.min_area
            continue
        end

        % Save
        overlaps{end + 1} = P(1:end - 1, :);
        tile_pairs{end + 1} = [i , j];
        
        % Plot the vertices of the intersected region
        if params.visualize
            hold on
            plot(P(:, 1), P(:, 2), 'ro')
            patch(Px, Py, 'r', 'FaceAlpha', 0.5)
            hold off
        end
    end
end

end

function w = in_poly(points, vertices)
% Calculates the winding number of the points.

n = size(vertices,1);
m = size(points,1);

q = zeros(2, n + 1);
q(:, 1:n) = vertices';
q(:, n + 1) = q(:, 1);

i = 1:n;
j = 2:n + 1;

ym = repmat(2, m, 1);
yn = repmat(2, 1, n);

w = abs(sum((2 * ((repmat(q(1, i) .* q(2, j) - q(2, i) .* q(1, j), m, 1) + points(:, 1) * (q(2,i) - q(2, j)) + points(:, 2) * (q(1, j) - q(1, i))) > 0) - 1) .* abs((q(ym, j) > points(:, yn)) - (q(ym, i) > points(:, yn))), 2) / 2);
end


function dist = dist2segment(p, v, w)
% Finds the minimum distance between point p and the line segment vw.
l2 = sum((v - w) .^ 2); % length squared

% Case: v == w
if l2 == 0 
    dist = sqrt(sum((p - v) .^ 2));
    return
end

% Line segment vw = v + t * (w - v)
% Solve for t of the projection (p_hat) of p onto the line
t = dot(p - v, w - v) / l2;
p_hat = v + t * (w - v);

% Case: Projected point is beyond v end of line segment
if t < 0
    dist = sqrt(sum((p - v) .^ 2));
    return
end

% Case: Projected point is beyond w end of line segment
if t > 1
    dist = sqrt(sum((p - w) .^ 2));
    return
end

% Case: Projected point is in line segment
dist = sqrt(sum((p - p_hat) .^ 2));
end


function close_enough = on_edge(X, Y, Xv, Yv, tol)
% Finds points close to the edges specified by the vertices.
if nargin < 5
    tol = 1e-5;
end

% Edge i is the line segment between [Xv1(i) Yv1(i)] and [Xv2(i) Yv2(i)]
Xv1 = Xv(1:end - 1);
Yv1 = Yv(1:end - 1);
Xv2 = Xv(2:end);
Yv2 = Yv(2:end);

% Find points within tolerance of edges
close_enough = arrayfun(@(x, y) any(arrayfun(@(xv1, yv1, xv2, yv2) dist2segment([x y], [xv1 yv1], [xv2 yv2]) < tol, Xv1, Yv1, Xv2, Yv2)), X, Y);
end


function params = parse_inputs(varargin)
% Create inputParser instance
p = inputParser;

% Tile size
p.addParameter('tile_size', [8000, 8000]);

% Tolerance for intersection detection
p.addParameter('tolerance', 1e-5);

% Minimum overlapping region area (relative to tile)
p.addParameter('min_area', 0.025); % default = 0.025 => 2.5% overlap

% Visualization
p.addParameter('visualize', false);

% Validate and parse input
p.parse(varargin{:});
params = p.Results;

end