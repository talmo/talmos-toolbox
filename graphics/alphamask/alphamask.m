function hOVM = alphamask(BW, color, transparency, ax)
% ALPHAMASK:  Overlay image with semi-transparent mask
%
% Overlays a semi-transparent mask over an image.  By default the 
%   currently displayed figure is overlain.
% Options include overlay colour and opacity.
% Returns a handle to the overlay mask.
%
% Usage:
%   hOVM = alphamask(bwMask, [colour, transparency, axHandle])
%           bwMask: logical matrix representing mask
%           colour: vector of three rgb values in range [0, 1] (optional; default [0 0 1])
%     transparency: scalar in range [0, 1] representing overlay opacity (optional; default 0.6)
%         axHandle: handle to axes on which to operate (optional; default current axes)
%             hOVM: handle to overlay image is returned
%
% Example:
%   figure;
%   I = peaks(200);
%   bwMask = eye(200);
%   imshow(I, [], 'Colormap', hot);
%   alphamask(bwMask, [0 0 1], 0.5);
%
% See also IMSHOW, CREATEMASK

% v0.5 (Feb 2012) by Andrew Davis -- addavis@gmail.com

% Check arguments
if ~exist('BW', 'var') || ~ismatrix(BW), error('bwMask matrix is a required argument'); end
if ~exist('color', 'var'), color = [0 0 1]; end
if ~exist('transparency', 'var'), transparency = 0.6; end
if ~exist('ax', 'var'), ax = gca; end
if ~isvector(color) || ~isscalar(transparency) || ~ishandle(ax), error('One or more arguments is not in the correct form'); end
% maskRange = max(max(BW))-min(min(BW));
% if maskRange ~= 1 && maskRange ~= 0, error('bwMask must consist only of the values 0 and 1'); end;

if ischar(color); color = name2rgb(color); end

% Create colour image and overlay it
rgbI = cat(3, color(1)*ones(size(BW)), color(2)*ones(size(BW)), color(3)*ones(size(BW)));

nextPlot0 = ax.NextPlot;
ax.NextPlot = 'add';

hOVM = imshow(rgbI, 'Parent', ax);
set(hOVM, 'AlphaData', BW*transparency);       % use mask values as alpha channel of overlay

ax.NextPlot = nextPlot0;

if nargout < 1; clear hOVM; end

end