function S_roi = stackroi(S, roi)
%STACKROI Extracts a set of pixels per frame in a stack.
% Usage:
%   S_roi = stackroi(S, roi) % binary mask
%   S_roi = stackroi(S, roi_rect) % [x y w h]
%   S_roi = stackroi(S, pts) % [x1 y1; x2 y2; ...]
%
% See also: getrect

S = validate_stack(S);
sz = size(S(:,:,1,1));

if isequal(sz, size(roi)) % mask
    ind = find(roi);
elseif numel(roi) == 4 % rect
    roi = round(roi);
    [j,i] = meshgrid(roi(1):(roi(1)+roi(3)), roi(2):(roi(2)+roi(4)));
    ind = sub2ind(sz, i, j);
elseif size(roi,2) == 2 % pts
    roi = round(roi);
    ind = sub2ind(sz, roi(:), roi(:));
else
    error('Invalid ROI specified.')
end

S = arr2cell(S,3);
S_roi = cf(@(s) stackfun(@(x) x(ind), s), S);
S_roi = cat(3, S_roi{:});

end

