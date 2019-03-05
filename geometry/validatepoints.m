function [Px, Py] = validatepoints(Px, Py)
%VALIDATEPOINTS Validates a list of 2-D points and returns them as column vectors.
% Usage:
%   [Px, Py] = validatepoints(Px, Py)
%   P = validatepoints(Px, Py)
%   ... = validatepoints(P)
%
% Args:
%   Px, Py: vectors of the X and Y components of the points
%   P: matrix of points; or cell array (vector) of points
%
% Returns:
%   Px, Py: vectors of the X and Y components of the points
%   P: Mx2 numeric array
%
% Notes:
%   - This function throws an error if the input points are not valid.
%   - When size(P) == [2, 2], P is assumed to vertical, i.e.,
%       Px = P(:, 1) and Py = P(:, 2).
%   - Validity criteria, where M is the number of points, are:
%       For single cell input:
%           numel(P) == M && ...
%           all(cellfun('prodofsize', P) == 2)
% 
%       For single numeric array input:
%           ndims(P) == 2 && ...
%           prod(size(P)) / 2 == M
%
%       For the individual component vectors:
%           isnumeric(Px) && isnumeric(Py) && ...
%           numel(Px) == numel(Py)
%
% See also: validateattributes

% Check number of arguments
narginchk(1, 2)

% Single input format
if nargin == 1
    P = Px;
    if iscell(Px)
        validateattributes(P, {'cell'}, {'vector', 'nonempty'})
        assert(all(cellfun('prodofsize', P) == 2), ... 
            'All elements of cell array must have two components.')
        
        % Split into vectors
        [Px, Py] = cellfun(@(p) deal(p(1), p(2)), P);
    else
        validateattributes(P, {'numeric'}, {'2d', 'nonempty'})
        assert(any(size(P) == 2), 'Point matrix must have at least one dimension of size 2.')
        if size(P, 2) == 2
            % Vertical array (Mx2)
            Px = P(:, 1);
            Py = P(:, 2);
        else
            % Horizontal array (2xM)
            Px = P(1, :);
            Py = P(2, :);
        end
    end
    clear P
end

% Validate component vectors
validateattributes(Px, {'numeric'}, {'nonempty', 'vector'})
validateattributes(Py, {'numeric'}, {'nonempty', 'vector'})
assert(numel(Px) == numel(Py), 'Component vectors must contain the same number of elements.')

% Shape components into vertical vectors
Px = Px(:);
Py = Py(:);

% Output
if nargout < 2
    Px = [Px Py];
end
end

