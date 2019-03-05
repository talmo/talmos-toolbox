function bb = ref2bb(R)
%REF2BB Converts a spatial reference object (imref2d) to a bounding box.
% Usage:
%   bb = ref2bb(R)

bb = boundingBox([R.XWorldLimits; R.YWorldLimits]');


end

