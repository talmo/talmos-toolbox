function map = redbluelight(N, dark)
%REDBLUELIGHT Red and blue colormap going from blue to white to red.
% Usage:
%   map = redbluelight(N)
% 
% Args:
%   N: number of samples in the colormap (default: 64)
%
% Returns:
%   map: N x 3 matrix of RGB colors
%
% Example:
%   imagesc(repmat(linspace(-1,1,200),100,1)),colorbar,colormap redbluelight
% 
% See also: colormap, parula, redblue

if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      N = size(get(groot,'DefaultFigureColormap'),1);
   else
      N = size(f.Colormap,1);
   end
end

if nargin < 2 || isempty(dark); dark = false; end


% similar to redbluecmap (bioinformatics toolbox)
% red =  [0.403921568627451                          0         0.12156862745098];
% blue = [0.0196078431372549         0.188235294117647         0.380392156862745];

red = [1 0 0];
blue = [0 0 1];

mid_col = [1 1 1];
if dark; mid_col = [0 0 0]; end


red_hsv = rgb2hsv(red);
mid_hsv = rgb2hsv(mid_col);
blue_hsv = rgb2hsv(blue);

basis_hsv = [
    red_hsv .* [1 1 1]
    red_hsv .* [1 0.5 1]
    mid_hsv
    blue_hsv .* [1 0.5 1]
    blue_hsv .* [1 1 1]
    ];

% red = [1 0.8 1] .* rgb2hsv(red);

% basis = [
%     red
%     mid_col
%     blue
%     ];

% basis_hsv = rgb2hsv(basis);


basis = hsv2rgb(basis_hsv);

P = size(basis,1);
map = interp1(1:size(basis,1), basis, linspace(1,P,N), 'linear');
% map_hsv = interp1(1:size(basis_hsv,1), basis_hsv, linspace(1,P,N), 'linear');

% map = hsv2rgb(map_hsv);

end
