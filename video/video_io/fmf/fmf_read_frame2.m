function frame = fmf_read_frame2(vinfo, frame_num)
%FMF_READ_FRAME2 Reads a frame of an FMF file.
% Usage:
%   frame = fmf_read_frame2(vinfo, frame_num)
%
% Args:
%   vinfo: video info structure from video_open()
%   frame_num: frame to read (1-N)
%
% See also: video_open

% Calculate position of frame data within file
frm_sz = prod(vinfo.fmf.framesize);
chunk_skip = vinfo.fmf.chunksize - frm_sz;
pos = (frame_num - 1) * vinfo.fmf.chunksize + chunk_skip;

% Seek to beginnng of frame
fseek(vinfo.fmf.fid, vinfo.fmf.header_bytes + pos, 'bof');

% Read frame
frame = permute(reshape(fread(vinfo.fmf.fid, frm_sz, '*uint8'), [vinfo.sz vinfo.sy vinfo.sx]), [3 2 1]);

end

