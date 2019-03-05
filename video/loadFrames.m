function [frames, numFrames] = loadFrames(videoPath, idx, reload)
%LOADFRAMES Loads frames with cache.
% Usage:
%   frames = loadFrames(videoPath)
%   frames = loadFrames(videoPath, idx) % [] = all
%   frames = loadFrames(videoPath, idx, true) % force reload from disk
%   [frames, numFrames] = loadFrames(_)
%
% See also: readFrames
stic;

if nargin < 2; idx = []; end
if nargin < 3; reload = false; end

videoPath = abspath(videoPath);
inCache = false;

persistent filenames frameNums data;
if isempty(filenames)
    filenames = {};
    frameNums = {};
    data = {};
else
    cachedPaths = ismember(filenames, videoPath);
    cachedFrames = cellfun(@(x) isequal(x, idx), frameNums);
    
    inCache = cachedPaths & cachedFrames;
end

if any(inCache) && ~reload
    frames = data{find(inCache,1)};
    printf('Loaded *%d* frames from *cache*. [%.2fs]', size(frames,4), stoc)
else
    frames = readFrames(videoPath, idx);
    filenames{end+1} = videoPath;
    frameNums{end+1} = idx;
    data{end+1} = frames;
    printf('Loaded and cached *%d* frames from *disk*. [%.2fs]', size(frames,4), stoc)
end

numFrames = size(frames,4);

end
