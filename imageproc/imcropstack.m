function [S,crop_rect] = imcropstack(I, crop_rect, varargin)
%IMCROPSTACK Crop a stack of images.
% Usage:
%   [S,crop_rect] = bwcropstack(I, crop_rect)
% 
% Args:
%   I: 3d or 4d stack of images
%   crop_rect: if specified, applies the crop to the stack (default: [])
%
% Params:
%   'Exact': if true, returns every section in a cell array with exact fit (default: false)
% 
% Returns:
%   S: cropped stack
%   crop_rect: computed bounding box(es) in [x y width height] format
% 
% See also: bwcrop, imcrop

if nargin < 2; crop_rect = []; end
if ischar(crop_rect); varargin = [{crop_rect},varargin]; crop_rect = []; end
p = parse_params(varargin, {'Exact',false});

ND = ndims(I);
if ND == 3; I = permute(I,[1 2 4 3]); end

if isempty(crop_rect)
    if p.Exact
        crop_rect = zeros(size(I,4),4);
        for i = 1:size(I,4)
            BW = abs(I(:,:,:,i)) > 0;
            BWx = sum(BW,1) > 0;
            BWy = sum(BW,2) > 0;
            x0 = find(BWx,1,'first'); x1 = find(BWx,1,'last');
            y0 = find(BWy,1,'first'); y1 = find(BWy,1,'last');
            crop_rect(i,:) = [x0, y0, x1-x0+1, y1-y0+1];
        end
    else
        BW = sum(abs(I),4) > 0;
        BWx = sum(BW,1) > 0;
        BWy = sum(BW,2) > 0;
        
        x0 = find(BWx,1,'first'); x1 = find(BWx,1,'last');
        y0 = find(BWy,1,'first'); y1 = find(BWy,1,'last');
        crop_rect = [x0, y0, x1-x0, y1-y0];
    end
end

if p.Exact
    S = cell1(size(I,4));
    for i = 1:numel(S)
        r = crop_rect(i,2):(crop_rect(i,2) + crop_rect(i,4));
        c = crop_rect(i,1):(crop_rect(i,1) + crop_rect(i,3));
        S{i} = I(r,c,:,i);
    end
else
    r = crop_rect(2):(crop_rect(2) + crop_rect(4));
    c = crop_rect(1):(crop_rect(1) + crop_rect(3));
    S = I(r,c,:,:);
end

if ND == 3 && ~iscell(S); S = permute(S,[1 2 4 3]); end
end
