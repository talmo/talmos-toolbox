function tiled = tilestacks(S, numCols, emptyPadval)
%TILESTACKS Tiles stacks into a grid with padding.
% Usage:
%   tiled = tilestacks(S, numCols)
%   tiled = tilestacks(S, numCols, emptyPadval)
% 
% Args:
%   S: cell array of stacks
%   numCols: number of columns in the tile grid
%   emptyPadval: scalar value to use for empty grid tiles (default: NaN)
% 
% See also: catpadarr

if nargin < 2; numCols = ceil(sqrt(numel(S))); end
if nargin < 3; emptyPadval = NaN; end

% Tile size
h = size(S{1},1);
w = size(S{1},2);

% Compute number of rows needed
n = numel(S);
numRows = ceil(n / numCols);

% Expand stacks to size of grid
if n < numRows*numCols
    S{numRows*numCols} = [];
end

% Fill missing cells in with an empty frame
isMissing = cellfun(@isempty, S);
if any(isMissing)
    S(isMissing) = {repmat(emptyPadval,h,w)};
end

% Reshape into grid
S = reshape(S,numCols,numRows)';

% Concatenate columns
tiled = cell(numRows,1);
for i = 1:numRows
    tiled{i} = catpadarr(2,S(i,:),'replicate');
end

% Concatenate rows
if numel(tiled) > 1
    tiled = catpadarr(1,tiled,'replicate');
else
    tiled = tiled{1};
end

end
