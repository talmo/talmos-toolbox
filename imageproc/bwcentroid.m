function [ctr_x, ctr_y] = bwcentroid(BW)
%BWCENTROID Returns the centroid of a binary mask.
% Usage:
%   [ctr_x, ctr_y] = bwcentroid(BW)
%   ctr = bwcentroid(BW)

[ctr_y, ctr_x] = find(BW);

ctr_x = mean(ctr_x);
ctr_y = mean(ctr_y);

if nargout < 2; ctr_x = [ctr_x, ctr_y]; end

end

