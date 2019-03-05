function [h, pts, pixel_boxes] = bwoutlinepixels(BW, varargin)
%BWOUTLINEPIXELS Plots boxes around each nonzero pixel in BW.
% Usage:
%   bwoutlinepixels(BW)
%   bwoutlinepixels(BW, ...) % params for plot
%   [h, pts, pixel_pts] = bwoutlinepixels(_)
% 
% Args:
%   BW: logical mask
% 
% Returns:
%   h: handle to lines
%   pts: points for all bounding boxes
% 
% See also: plot, mask2pts

% Get centers of each point in BW as a cell
pixel_boxes = num2cell(mask2pts(BW~=0),2);

% Compute bounding boxes
offsets = [
    -0.5 -0.5 % left-top
     0.5 -0.5 % right-top
     0.5  0.5 % right-bottom
    -0.5  0.5 % left-bottom
    -0.5 -0.5 % close polygon
    ];
pixel_boxes = cf(@(x)x+offsets, pixel_boxes);

% Concatenate into a single line delimited by NaN (more efficient than separate objects)
pts = celljoin(pixel_boxes);

% Plot!
h = plot(pts(:,1),pts(:,2),varargin{:});


if nargout < 1; clear h; end
end
