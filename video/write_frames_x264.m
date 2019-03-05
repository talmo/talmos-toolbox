function write_frames_x264(mov, outPath, fps, verbose)
%WRITE_FRAMES_X264 Write frames in X264 format via ffmpeg.
% Usage:
%   write_frames_x264(mov, outPath, fps, verbose)
% 
% Args:
%   mov: cell, 3-d or 4-d stack
%   outPath: output path (.mp4)
%   fps: framerate
%   verbose: if false, disables some ffmpeg logging (default: true)
% 
% See also: write_video

if nargin < 4 || isempty(verbose); verbose = true; end

tmpPath = [tempname '.avi'];
write_frames(mov,tmpPath,'FPS',fps,'Profile','Uncompressed AVI')

logging = '';
if ~verbose; logging = '-hide_banner -nostats -loglevel 0 '; end

stic;
system(['ffmpeg ' logging '-y -i ' tmpPath ' -c libx264 -preset veryslow -crf 18 ' outPath]);
% system(['ffmpeg ' logging '-y -i ' tmpPath ' -c h264_nvenc -crf 18 ' outPath]);
delete(tmpPath)
stocf('Saved as x264: %s (%s)', outPath, bytes2str(outPath))

end
