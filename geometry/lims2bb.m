function bb = lims2bb(XLims, YLims)
%LIMS2BB Returns a bounding box the specified X and Y limits.
% Usage:
%   bb = lims2bb(XLims, YLims)
%
% See also: minaabb, tform_bb2bb, sec_bb, ref_bb

bb = minaabb([XLims' YLims']);

end

