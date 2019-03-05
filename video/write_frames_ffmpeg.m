function write_frames_ffmpeg(mov, outPath, fps, preset, verbose)
%WRITE_FRAMES_FFMPEG Write frames in different formats via ffmpeg.
% Usage:
%   write_frames_ffmpeg(mov, outPath, fps, preset, verbose)
% 
% Args:
%   mov: cell, 3-d or 4-d stack
%   outPath: output path
%   fps: framerate (default: 25)
%   preset: preset profile for video encoding to use (default: 'x264_hq')
%           if no match for any presets, this parameter will be interpreted
%           as a set of command line flags (e.g., '-c:v libxvid -q:v 18')
%   verbose: if false, disables some ffmpeg logging (default: true)
% 
% See also: write_frames, VideoWriter

if nargin < 3 || isempty(fps); fps = 25; end
if nargin < 4 || isempty(preset); preset = 'x264_hq'; if ischar(fps); preset = fps; fps = 25; end; end
if nargin < 5 || isempty(verbose); verbose = true; end

switch preset
    case {'libxvid', 'xvid'}
        % high quality (usual q range is [18, 45], lower is better)
        preset_cmd = '-c:v libxvid -q:v 10';
    case {'libx264','x264'}
        % Ref: https://trac.ffmpeg.org/wiki/Encode/H.264
        preset_cmd = strjoin({
            '-c:v libx264'
            % Codec presets: ultrafast,superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo
            %   Choose slowest tolerable
            '-preset veryslow'
            % Constant rate factor (crf): 18-28 is a good range with 18 usually being perceptibly indistinguishable from lossless
            '-crf 14'
            % VF macro: this makes sure the dimensions are multiples of 2 (no green borders)
            %   Ref: https://stackoverflow.com/questions/20847674/ffmpeg-libx264-height-not-divisible-by-2
            '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"'
            % Pixel format compatibility
            '-pix_fmt yuv420p'
            },' ');
    case 'x264_compatibility'
        preset_cmd = strjoin({
            '-c:v libx264'
            '-preset slow'
            '-crf 14'
            '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"'
            '-pix_fmt yuv420p'
            % Compatibility: Apple TV 3 and later, iPad 2 and later, iPhone 4s and later
            % Ref: https://trac.ffmpeg.org/wiki/Encode/H.264#Compatibility
            '-profile:v high -level 4.0'
            },' ');
    case {'hq','x264_hq'}
        preset_cmd = strjoin({
            '-c:v libx264'
            '-preset slow'
            '-crf 14'
            '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"'
            '-pix_fmt yuv420p'
            '-tune film'
            },' ');
    case {'anim','animation','x264_anim','x264_animation'}
        preset_cmd = strjoin({
            '-c:v libx264'
            '-preset slow'
            '-crf 14'
            '-vf "scale=trunc(iw/2)*2:trunc(ih/2)*2"'
            '-pix_fmt yuv420p'
            '-tune animation'
            '-x264opts colormatrix=bt709'
            },' ');
    case {'seeking','mmread','mmreader'}
        preset_cmd = strjoin({
            '-c:v libx264'
            '-crf 14'
%             '-preset slow'
            '-preset superfast'
            '-pix_fmt yuv420p'
            '-g 1' % grouping keyframe interval
            % Sets the GOP to 1 to make every frame a keyframe to ensure 
            % accurate seeking (at least in mmread/Windows x64)
            });
    otherwise
        preset_cmd = preset;
end

logging = '';
if ~verbose; logging = '-hide_banner -nostats -loglevel 0 '; end

if iscell(mov)
    mov = cat(4, mov{:});
elseif isnumeric(mov)
    % Add singleton dimension to image stack
    if ndims(mov) == 3
        mov = permute(frames, [1 2 4 3]);
    end
end
 
% Write temp uncompressed movie
% tmpPath = [tempname '.avi'];
% write_frames(mov,tmpPath,'FPS',fps,'Profile','Uncompressed AVI')

% Write temp frames
tempFolder = tempname();
if exists(tempFolder); rmdir(tempFolder,'s'); end
mkdir(tempFolder)
fns = af(@(i)ff(tempFolder,sprintf('%05d.png',i)),1:size(mov,4));
if isparpoolopen
    parfor i = 1:size(mov,4); imwrite(mov(:,:,:,i),fns{i}); end
else
    for i = 1:size(mov,4); imwrite(mov(:,:,:,i),fns{i}); end
end

% Transcode
try
    fps_cmd = sprintf('-framerate %d',fps);
    stic;
    system(['ffmpeg ' logging '-y ' fps_cmd ' -i "' ff(tempFolder, '%05d.png') '" ' preset_cmd ' "' outPath '"']);
%     delete(tmpPath)
    rmdir(tempFolder,'s')
    stocf('Saved: %s (%s)', outPath, bytes2str(outPath))
catch ME
%     delete(tmpPath)
    rmdir(tempFolder,'s')
    rethrow(ME)
end
end
