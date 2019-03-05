function frames = readFramesPar(vidPath, framesIdx, varargin)
%READFRAMESPAR Reads frames by chunking and parallelizing with VideoReaderOCV.
% Usage:
%   frames = readFramesPar(vidPath, framesIdx)
%   frames = readFramesPar(vidPath, framesIdx, 'grayscale', false)
% 
% Args:
%   vidPath: path to video file
%   framesIdx: frame indices
%
% Params:
%   grayscale: speeds up reading if specified (default: [] = autodetect)
%
% Returns:
%   frames: 4-D uint8 stack
% 
% See also: VideoReaderOCV

% Parse params
params = parse_params(varargin, struct('grayscale', []));

% Autodetect grayscale once
grayscale = params.grayscale;
if isempty(grayscale)
    vid = VideoReaderOCV(vidPath);
    grayscale = vid.grayscale;
    clear vid
end

% Split into worker chunks
pool = gcp(); N = pool.NumWorkers;
N = min(N, numel(framesIdx));
framesIdxs = chunk2cell(framesIdx, ceil(numel(framesIdx)/N));

% Run
frames = cell1(numel(framesIdxs));
parfor i = 1:numel(framesIdxs)
    vid = VideoReaderOCV(vidPath,'grayscale',grayscale);
    frames{i} = vid.read(framesIdxs{i});
end
frames = cellcat(frames,4);

end
