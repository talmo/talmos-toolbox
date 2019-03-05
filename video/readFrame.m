function frame = readFrame(videoPath, frameNum)
%READFRAME Reads a single video frame via mmread.
% Usage:
%   frame = readFrame(videoPath, frameNum)
% 
% Returns:
%   frame:
%       Numeric array containing the frame data
% 
% See also: mmread

video = mmread(videoPath, frameNum, [], false, true);
frame = video.frames.cdata;

end

