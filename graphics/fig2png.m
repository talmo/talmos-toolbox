function pngPaths = fig2png(figPath)
%FIG2PNG Convert .fig figures to .png.
% Usage:
%   fig2png
%   fig2png(figPath)
%   pngPaths = fig2png
%   pngPaths = fig2png(figPath)

% Input
if nargin < 1
    figPath = cd;
end

% Find paths
figPaths = dir_ext(figPath, 'fig', true);
basePaths = cellfun(@fileparts, figPaths, 'UniformOutput', false);
filenames = cellfun(@(x) [get_filename(x, true) '.png'], figPaths, 'UniformOutput', false);
pngPaths = fullfile(basePaths, filenames);

% Convert
for i = 1:numel(pngPaths)
    figHandle = openfig(figPaths{i});
    saveas(figHandle, pngPaths{i});
    close(figHandle)
end

% Output
if nargout < 1
    clear pngPaths
end
end

