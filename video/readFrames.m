function [frames, numFrames] = readFrames(videoPath, frameNums, isGrayscale)
%READFRAMES Reads frames using mmread.
% Usage:
%   frames = readFrames(videoPath, frameNums)
%   frames = readFrames(videoPath, frameNums, true) % for grayscale videos
%   [frames, numFrames] = readFrames(_)

if ~ischar(videoPath) || ~exists(videoPath)
    error('Invalid video path specified.')
end
if nargin < 2
    frameNums = [];
end
if nargin < 3
    isGrayscale = []; % auto
end

time = []; % seek by frame number, not time
disableVideo = false;
disableAudio = true;
matlabCommand = '';
trySeeking = true; % faster
useFFGRAB = true; % faster

video = mmread(videoPath, frameNums, time, disableVideo, disableAudio, ...
    matlabCommand, trySeeking, useFFGRAB);

frames = cat(4, video(end).frames.cdata);

% Auto detect
if isempty(isGrayscale)
    isGrayscale = isequal(frames(:,:,1,1), frames(:,:,2,1));
end

if isGrayscale
    frames = frames(:,:,1,:);
end

numFrames = size(frames, 4);

end

