function frames = readFrames_old(vidFilePath)
%READFRAMES Reads in the frames of a video.
% Usage:
%   frames = readFrames(vidFilePath)
%
% Returns:
%   frames: [height, width, numFrames] uint8 array

v = VideoReader(vidFilePath);
numFrames = ceil(v.FrameRate * v.Duration);
frames = zeros(v.Height, v.Width, numFrames + 100, 'uint8');

i = 0;
while v.hasFrame()
    i = i + 1;
    frames(:, :, i) = rgb2gray(v.readFrame());
end
frames = frames(:, :, 1:i);
end
