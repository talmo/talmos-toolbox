function bb = sz2bb(sz)
%SZ2BB Converts the output of size to a bounding box around an image of the same size.
% Usage:
%   bb = sz2bb(sz)
%
% Note: This produces the same output as ref_bb(imref2d(sz)).


bb = minaabb(double([0.5 0.5; sz + [0.5 0.5]]));

end

