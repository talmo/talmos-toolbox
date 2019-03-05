function num_bb = ufmf_get_num_bb(header, frame)
%UFMF_GET_NUM_BB Returns the number of foreground bounding boxes in a frame.

if ischar(header)
    % header = path to video
    header = ufmf_read_header(header);
end

FRAME_CHUNK = 1;

fp = header.fid;

% Move pointer to frame
fseek(fp,header.frame2file(frame),'bof');

% read in the chunk type: 1
chunktype = fread(fp,1,'uchar');
if chunktype ~= FRAME_CHUNK,
    error('Expected chunktype = %d at start of frame, got %d',FRAME_CHUNK,chunktype);
end
% read in timestamp: 8
timestamp = fread(fp,1,'double');
if header.version == 4,
    % number of points: 2
    num_bb = fread(fp,1,'uint32');
else
    % number of points: 2
    num_bb = fread(fp,1,'ushort');
end


end

