function [XLims, YLims] = bb2lims(bb)
%BB2LIMS Returns the X and Y limits of the bounding box.
% Usage:
%   [XLims, YLims] = bb2lims(bb)
%
% See also: sz2lims, sz2bb, minaabb

XLims = [min(bb(:, 1)), max(bb(:, 1))];
YLims = [min(bb(:, 2)), max(bb(:, 2))];
end

