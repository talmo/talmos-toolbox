function bb = ufmf_get_bb(header, frame)
%UFMF_GET_BB Returns the foreground bounding boxes of a frame.

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
    npts = fread(fp,1,'uint32');
else
    % number of points: 2
    npts = fread(fp,1,'ushort');
end

if header.is_fixed_size,
    bb = fread(fp,npts*2,'uint16');
    bb = reshape(bb,[npts,2]);
    % read sideways
    bb = bb(:,[2,1]);
    %data = fread(fp,npts*header.max_width*header.max_height*header.bytes_per_pixel,['*',header.dataclass]);
    % TODO: handle colorspaces other than MONO8 and RGB8
    %data = reshape(data,[header.ncolors,npts,header.max_height,header.max_width]);
else
    bb = zeros(npts,4);
    %data = cell(1,npts);
    for i = 1:npts,
        bb(i,:) = fread(fp,4,'ushort');
        fseek(fp, bb(i,3)*bb(i,4)*header.bytes_per_pixel, 'cof');
        %width = bb(i,4); height = bb(i,3);
        %data{i} = fread(fp,width*height*header.bytes_per_pixel,['*',header.dataclass]);
        % TODO: handle colorspaces other than MONO8 and RGB8
        %data{i} = reshape(data{i},[header.ncolors,height,width]);
    end
    % images are read sideways
    bb = bb(:,[2,1,4,3]);
end
% matlab indexing
bb(:,1:2) = bb(:,1:2)+1;

end

