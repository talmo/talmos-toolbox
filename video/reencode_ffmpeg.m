function [outputPath, cmd] = reencode_ffmpeg(inputPath, varargin)
%REENCODE_FFMPEG Convenience wrapper for reencoding videos with ffmpeg.
% Usage:
%   [outputPath, cmd] = reencode_ffmpeg(inputPath, ...)
% 
% Args:
%   inputPath: path to input video
% 
% See also: write_frames_ffmpeg

% Parse params
defaults = struct();
defaults.outputPath = []; % auto
defaults.ffmpegPath = 'ffmpeg';
defaults.crf = 15; % compression rate factor
defaults.sizeFactor = 8; % width/height will be a multiple of this
defaults.resizeMethod = 'crop'; % 'crop' or 'scale'
defaults.fps = 25;
params = parse_params(varargin, defaults);

outputPath = params.outputPath;
if isempty(outputPath); outputPath = repext(inputPath, 'sf.mp4'); end

% Setup command
cmd = {
    ['"' params.ffmpegPath '"']
    '-y' % don't ask for confirmation (e.g., for overwriting)
    ['-i "' inputPath '"']
    '-c:v libx264' % necessary (though other backends may also work)
    '-preset superfast' % necessary
    '-g 1' % group of pictures (GOP) set to 1, disabing B-frames and making seeking reliable
    '-pix_fmt yuv420p' % necessary
    sprintf('-framerate %d', params.fps) % should be 25 ideally
    sprintf('-crf %d', params.crf) % logarithmic scale, 15 = visually lossless, 25 = lossy
    };

% Resizing
if params.resizeMethod == "crop"
    cmd{end+1} = sprintf('-vf "crop=w=trunc(iw/%d)*%d:h=trunc(ih/%d)*%d:x=0:y=0"', params.sizeFactor, params.sizeFactor, params.sizeFactor, params.sizeFactor);
elseif params.resizeMethod == "scale"
    cmd{end+1} = sprintf('-vf "scale=trunc(iw/%d)*%d:trunc(ih/%d)*%d"', params.sizeFactor, params.sizeFactor, params.sizeFactor, params.sizeFactor);
end

% Add output and build command
cmd{end+1} = ['"' outputPath '"'];
cmd = strjoin(cmd, ' ');

% Run!
proc = processManager('command',cmd);
proc.block();

end
