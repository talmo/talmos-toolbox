function pts = bwboundarypts(BW, conn)
%BWBOUNDARYPTS Wrapper for bwboundaries.
% Usage:
%   pts = bwboundarypts(BW)
% 
% Returns:
%   pts: cell array with [X Y] coordinates for the boundaries of each CC
%
% See also: bwboundaries, celljoin

if nargin < 2; conn = 8; end

if isnumeric(BW) % labels
    BW = bwccmasks(BW,conn);
    if size(BW,4) > 1
        pts = cellcat(stackfun(@(x)bwboundarypts(x,conn), BW, true));
    else
        pts = bwboundarypts(BW > 0,conn);
    end
elseif islogical(BW)
    pts = cf(@fliplr, bwboundaries(BW, conn, 'noholes'));
end

end

