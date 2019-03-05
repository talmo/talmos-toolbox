function fmf_header = fmf_header(video_path)
%FMF_HEADER Returns metadata about an FMF video file from its header.
% Usage:
%   fmf_header = fmf_header(video_path)
%
% See also: fmf_read_header, video_open

if nargin < 1
    video_path = uibrowse('*.fmf');
end

% convert filename to use absolute path
video_path = GetFullPath(video_path);

% store name and type
fmf_header.filename = video_path;
fmf_header.type = 'fmf';

% open file
fmf_header.fmf.fid = fopen(video_path, 'r');
if (fmf_header.fmf.fid == -1)
    error(['Unable to open file ' video_path]);
end

% read file version
fmf_header.fmf.version = fread(fmf_header.fmf.fid, 1, 'uint32');

% check file version
if (fmf_header.fmf.version == 1)
    % read file header
    fmf_header.fmf.format = 'MONO8';
    fmf_header.fmf.bpp = 8;
    fmf_header.fmf.framesize = fread(fmf_header.fmf.fid, [1 2], 'uint32');
    fmf_header.fmf.chunksize = fread(fmf_header.fmf.fid, 1, 'uint64');
    fmf_header.fmf.n_frames = fread(fmf_header.fmf.fid, 1, 'uint64');
    fmf_header.fmf.header_bytes = ftell(fmf_header.fmf.fid);
    % compute # frames from file size
    d = dir(video_path);
    flen = d.bytes;
    nf = floor((flen - fmf_header.fmf.header_bytes)./(fmf_header.fmf.chunksize));
    % adjust number of frames
    if (fmf_header.fmf.n_frames == 0)
        fmf_header.fmf.n_frames = nf;
    else
        fmf_header.fmf.n_frames = min(fmf_header.fmf.n_frames,nf);
    end
    % store number of frames
    fmf_header.n_frames = double(fmf_header.fmf.n_frames);
    % store frame size
    fmf_header.sx = fmf_header.fmf.framesize(1);
    fmf_header.sy = fmf_header.fmf.framesize(2);
    fmf_header.sz = fmf_header.fmf.bpp ./ 8;
    
elseif (fmf_header.fmf.version == 3)
    % read file header
    lenformat = fread(fmf_header.fmf.fid, 1, 'uint32');
    fmf_header.fmf.format = fread(fmf_header.fmf.fid, [1 lenformat], 'char=>char');
    fmf_header.fmf.bpp = fread(fmf_header.fmf.fid, 1, 'uint32');
    fmf_header.fmf.framesize = fread(fmf_header.fmf.fid, [1 2], 'uint32');
    fmf_header.fmf.chunksize = fread(fmf_header.fmf.fid, 1, 'uint64');
    fmf_header.fmf.n_frames = fread(fmf_header.fmf.fid, 1, 'uint64');
    fmf_header.fmf.header_bytes = ftell(fmf_header.fmf.fid);
    
    % compute # frames from file size
    d = dir(video_path);
    flen = d.bytes;
    nf = floor((flen - fmf_header.fmf.header_bytes)./(fmf_header.fmf.chunksize));
    
    % adjust number of frames
    if (fmf_header.fmf.n_frames == 0)
        fmf_header.fmf.n_frames = nf;
    else
        fmf_header.fmf.n_frames = min(fmf_header.fmf.n_frames,nf);
    end
    
    % store number of frames
    fmf_header.n_frames = double(fmf_header.fmf.n_frames);
    
    % store frame size
    fmf_header.sx = fmf_header.fmf.framesize(1);
    fmf_header.sy = fmf_header.fmf.framesize(2);
    fmf_header.sz = fmf_header.fmf.bpp ./ 8;
    
else
    error([video_path ' is not an fmf version 1 or 3 file']);
end

% FPS and duration
fmf_header.fps = fmf_get_fps(video_path);
fmf_header.duration = fmf_get_duration(video_path);

% Close file
fclose(fmf_header.fmf.fid);

end

