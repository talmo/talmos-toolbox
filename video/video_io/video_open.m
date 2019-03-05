% Open a video and return a handle to it.
%
%    vinfo = video_open(filename)
%
% where filename is a video file (or directory) that supports random access to
% frames returns a vinfo structure which serves as a handle for accessing 
% individual video frames.
%
%    vinfo = video_open(filename, [sx sy sz])
%
% where filename is a binary file (.bin) containing only raw frame data opens 
% the video using the given frame size.  The number of channels per frame is 
% given by sz (for example, sz=1 for grayscale, sz=3 for color).
%
%    vinfo = video_open(filename, cache_size)
%
% where filename is a video file that does not support random frame access 
% returns a vinfo structure that will read and cache multiple frames at a 
% time in order to mitigate the overhead of random access.  If unspecified, 
% cache_size is set to 20 frames (or video length if < 20).
%
% To treat a video that has been broken into multiple file segments as a 
% single video, use:
%
%    vinfo = video_open({'filename1','filename2',...}) or 
%    vinfo = video_open({'filename1','filename2',...}, cache_size)
%
% Opening .seq files requires Piotr's Matlab toolbox to be installed.
function vinfo = video_open(filename, cache_size)
   % check arguments
   if (nargin < 1), error('missing filename argument'); end
   % default cache size (# frames) for files not supporting random access
   if (nargin < 2), cache_size = 20; end
   % determine type of video

%% cell array of video files (recursive call to self)
   if (isa(filename,'cell'))
      % check that file list is nonempty
      if (isempty(filename)), error('filename list is empty'); end
      % store source and type
      vinfo.filename = filename;
      vinfo.type = 'vlist';
      % open each video in file list
      n_files = numel(filename);
      vinfo.vlist = cell([n_files 1]);
      for n = 1:n_files
         vinfo.vlist{n} = video_open(filename{n}, cache_size);
      end
      % compute total frames, check that video dimensions match
      n_frames = 0;
      sx = vinfo.vlist{1}.sx;
      sy = vinfo.vlist{1}.sy;
      sz = vinfo.vlist{1}.sz;
      for n = 1:n_files
         % check dimensions
         if ((sx ~= vinfo.vlist{n}.sx) || ...
             (sy ~= vinfo.vlist{n}.sy) || ...
             (sz ~= vinfo.vlist{n}.sz))
            error('mismatch in video dimensions when opening multiple files');
         end
         % update frame count
         n_frames = n_frames + vinfo.vlist{n}.n_frames;
      end
      % store number of frames
      vinfo.n_frames = n_frames;
      % store frame size
      vinfo.sx = sx;
      vinfo.sy = sy;
      vinfo.sz = sz;

%% folder/directory with frames stored as individual png files
   elseif (exist(filename,'dir'))
      % convert filename to use absolute path
      filename = absolute_path(filename);
      % check that frames subdirectory exists
      if (~exist(fullfile(filename, 'frames')))
         error([filename ' does not contain frames subdirectory']);
      end
      % store source and type
      vinfo.filename = filename;
      vinfo.type = 'dir';
      % get frame subdirectory list
      subdirs = dir(fullfile(filename, 'frames'));
      subdirs = subdirs(find([subdirs.isdir]));
      subdirs = { subdirs.name };
      subdirs = subdirs(3:end);
      % store subdirectory info
      vinfo.dir.subdirs = subdirs;
      vinfo.dir.subdir_size = 1000;    % frames stored per subdirectory
      vinfo.dir.frame_extn = '.png';   % frame filename extension
      if (~isempty(subdirs))
         vinfo.dir.name_len = numel(subdirs{1});
      else
         vinfo.dir.name_len = 6;       % default for up to 10^6 frames
      end
      % get number of frames
      if (~isempty(subdirs))
         vinfo.n_frames = ...
            str2num(subdirs{end}) + ...
            length(dir(fullfile(filename, 'frames', subdirs{end}))) - 2;
      else
         vinfo.n_frames = 0;
      end
      % get frame size
      if (vinfo.n_frames > 0)
         frame0 = imread(fullfile( ...
            filename, 'frames', subdirs{1}, ...
            [repmat('0',[1 vinfo.dir.name_len]) vinfo.dir.frame_extn]));
         [sx sy sz] = size(frame0);
         vinfo.sx = sx;
         vinfo.sy = sy;
         vinfo.sz = sz;
      else
         vinfo.sx = 0;
         vinfo.sy = 0;
         vinfo.sz = 1;
      end

%% .bin
   elseif ((exist(filename,'file')) && ...
      (numel(filename) > 4) && (strcmp(filename((end-3):end),'.bin')))
      % convert filename to use absolute path
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'bin';
      % open file
      vinfo.bin.fid = fopen(filename, 'r');
      if (vinfo.bin.fid == -1)
         error(['unable to open file ' filename]);
      end
      % second argument is actually frame dimensions (not cache size)
      vinfo.n_frames = 0;
      vinfo.sx = cache_size(1);
      vinfo.sy = cache_size(2);
      vinfo.sz = cache_size(3);
      % compute file length
      d = dir(filename);
      flen = d.bytes;
      vinfo.n_frames = floor(flen / ((vinfo.sx).*(vinfo.sy).*(vinfo.sz)));

%% .seq
   elseif ((exist(filename,'file')) && ...
      (numel(filename) > 4) && (strcmp(filename((end-3):end),'.seq')))
      % convert filename to use absolute path
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'seq';
      % get file info
      vinfo.seq.info = seqIo(filename, 'getInfo');
      % create seq reader
      vinfo.seq.sr = seqIo(filename, 'reader');
      % store frame count and size
      vinfo.n_frames = vinfo.seq.info.numFrames;
      vinfo.sx = vinfo.seq.info.height;
      vinfo.sy = vinfo.seq.info.width;
      vinfo.sz = vinfo.seq.info.imageBitDepth./8;
      
      % FPS and duration
      vinfo.fps = vinfo.seq.info.fps;
      vinfo.duration = vinfo.n_frames / vinfo.fps;
%% .fmf
   elseif ((exist(filename,'file')) && ...
      (numel(filename) > 4) && (strcmp(filename((end-3):end),'.fmf')))
      % convert filename to use absolute path
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'fmf';
      % open file
      vinfo.fmf.fid = fopen(filename, 'r');
      if (vinfo.fmf.fid == -1)
         error(['unable to open file ' filename]);
      end
      % read file version 
      vinfo.fmf.version = fread(vinfo.fmf.fid, 1, 'uint32');
      % check file version
      if (vinfo.fmf.version == 1)
         % read file header
         vinfo.fmf.format = 'MONO8';
         vinfo.fmf.bpp = 8;
         vinfo.fmf.framesize = fread(vinfo.fmf.fid, [1 2], 'uint32');
         vinfo.fmf.chunksize = fread(vinfo.fmf.fid, 1, 'uint64');
         vinfo.fmf.n_frames = fread(vinfo.fmf.fid, 1, 'uint64');
         vinfo.fmf.header_bytes = ftell(vinfo.fmf.fid);
         % compute # frames from file size
         d = dir(filename);
         flen = d.bytes;
         nf = floor((flen - vinfo.fmf.header_bytes)./(vinfo.fmf.chunksize));
         % adjust number of frames
         if (vinfo.fmf.n_frames == 0)
            vinfo.fmf.n_frames = nf;
         else
            vinfo.fmf.n_frames = min(vinfo.fmf.n_frames,nf);
         end
         % store number of frames
         vinfo.n_frames = double(vinfo.fmf.n_frames);
         % store frame size
         vinfo.sx = vinfo.fmf.framesize(1);
         vinfo.sy = vinfo.fmf.framesize(2);
         vinfo.sz = vinfo.fmf.bpp ./ 8;
      elseif (vinfo.fmf.version == 3)
         % read file header
         lenformat = fread(vinfo.fmf.fid, 1, 'uint32');
         vinfo.fmf.format = fread(vinfo.fmf.fid, [1 lenformat], 'char=>char');
         vinfo.fmf.bpp = fread(vinfo.fmf.fid, 1, 'uint32');
         vinfo.fmf.framesize = fread(vinfo.fmf.fid, [1 2], 'uint32');
         vinfo.fmf.chunksize = fread(vinfo.fmf.fid, 1, 'uint64');
         vinfo.fmf.n_frames = fread(vinfo.fmf.fid, 1, 'uint64');
         vinfo.fmf.header_bytes = ftell(vinfo.fmf.fid);
         % compute # frames from file size
         d = dir(filename);
         flen = d.bytes;
         nf = floor((flen - vinfo.fmf.header_bytes)./(vinfo.fmf.chunksize));
         % adjust number of frames
         if (vinfo.fmf.n_frames == 0)
            vinfo.fmf.n_frames = nf;
         else
            vinfo.fmf.n_frames = min(vinfo.fmf.n_frames,nf);
         end
         % store number of frames
         vinfo.n_frames = double(vinfo.fmf.n_frames);
         % store frame size
         vinfo.sx = vinfo.fmf.framesize(1);
         vinfo.sy = vinfo.fmf.framesize(2);
         vinfo.sz = vinfo.fmf.bpp ./ 8;
      else
         error([filename ' is not an fmf version 1 or 3 file']);
      end
      
      % FPS and duration
      vinfo.fps = fmf_get_fps(filename);
      vinfo.duration = fmf_get_duration(filename);

%% .sbfmf
   elseif ((exist(filename,'file')) && ...
      (numel(filename) > 6) && (strcmp(filename((end-5):end),'.sbfmf')))
      % convert filename to use absolute path
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'sbfmf';
      % open file
      vinfo.sbfmf.fid = fopen(filename, 'r');
      if (vinfo.sbfmf.fid == -1)
         error(['unable to open file ' filename]);
      end
      % read file header
      vinfo.sbfmf.nbytesver = double(fread(vinfo.sbfmf.fid,1,'uint32' ));
      vinfo.sbfmf.version = fread(vinfo.sbfmf.fid, vinfo.sbfmf.nbytesver);
      vinfo.sbfmf.framesize = fread(vinfo.sbfmf.fid, [1 2], 'uint32');
      sx = vinfo.sbfmf.framesize(1);
      sy = vinfo.sbfmf.framesize(2);
      vinfo.sbfmf.n_frames = double(fread(vinfo.sbfmf.fid,1,'uint32'));
      vinfo.sbfmf.differencemode = double(fread(vinfo.sbfmf.fid,1,'uint32'));
      vinfo.sbfmf.indexloc = double(fread(vinfo.sbfmf.fid,1,'uint64'));
      vinfo.sbfmf.bgcenter = ...
         reshape(fread(vinfo.sbfmf.fid,sx*sy,'double'),[sx sy]);
      vinfo.sbfmf.bgstd = ...
         reshape(fread(vinfo.sbfmf.fid,sx*sy,'double'),[sx sy]);
      fseek(vinfo.sbfmf.fid,vinfo.sbfmf.indexloc,'bof');
      vinfo.sbfmf.frame2file = ...
         fread(vinfo.sbfmf.fid,vinfo.sbfmf.n_frames,'uint64');
      % store number of frames
      vinfo.n_frames = vinfo.sbfmf.n_frames;
      % store frame size
      vinfo.sx = sx;
      vinfo.sy = sy;
      vinfo.sz = 1;
      
%% .ufmf
   elseif ((exist(filename,'file')) && ...
      (numel(filename) > 5) && (strcmp(filename((end-4):end),'.ufmf')))
      % convert filename to use absolute path
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'ufmf';
      % read file
      vinfo.ufmf = ufmf_read_header(filename);
      % store number of frames
      vinfo.n_frames = vinfo.ufmf.nframes;
      % store frame size
      vinfo.sx = vinfo.ufmf.nc;
      vinfo.sy = vinfo.ufmf.nr;
      vinfo.sz = 1;
      
      % FPS and duration
      vinfo.fps = ufmf_get_fps(filename);
      vinfo.duration = ufmf_get_duration(filename);

%% .avi
   elseif ((exist(filename,'file')) && ...
      (numel(filename) > 4) && (strcmp(filename((end-3):end),'.avi')))     
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'vidobj';
      % read file
      vinfo.vidobj = VideoReader(filename);
      % store number of frames
      vinfo.n_frames = vinfo.vidobj.NumberOfFrames;
      % store frame size
      vinfo.sx = vinfo.vidobj.Height;
      vinfo.sy = vinfo.vidobj.Width;
      vinfo.sz = 1;
      
      % FPS and duration
      vinfo.fps = vinfo.vidobj.FrameRate;
      vinfo.duration = vinfo.n_frames / vinfo.fps;

%% mmread fallback
   elseif (exist(filename,'file'))
      % use mmread to read the file
      filename = absolute_path(filename);
      % store name and type
      vinfo.filename = filename;
      vinfo.type = 'mmread';
      % check that file can be opened
      fid = fopen(filename, 'r');
      if (fid == -1)
         error(['unable to open file ' filename]);
      else
         fclose(fid);
      end
      % use mmread to obtain file information
      loaded_all = 0;
      if isinf(cache_size)
        v = mmread(vinfo.filename);
        loaded_all = 1;
      else
        v = mmread(vinfo.filename, 1); 
      end
      vinfo.mmread.width         = v.width;
      vinfo.mmread.height        = v.height;
      vinfo.mmread.rate          = v.rate;
      vinfo.mmread.nrFramesTotal = v.nrFramesTotal;
      vinfo.mmread.totalDuration = v.totalDuration;
      % store number of frames
      vinfo.n_frames = abs(vinfo.mmread.nrFramesTotal);
      % store frame size
      vinfo.sx = vinfo.mmread.height;
      vinfo.sy = vinfo.mmread.width;
      vinfo.sz = 1;
      % reduce cache size if longer than video
      cache_size = min(cache_size, vinfo.n_frames);
      % initialize frame cache
      vinfo.mmread.cache.cache_size = cache_size;
      if loaded_all
        vinfo.mmread.cache.data = ...
               zeros([vinfo.sx vinfo.sy vinfo.sz cache_size],'uint8');
        for n = 1:cache_size
          vinfo.mmread.cache.data(:,:,:,n) = v.frames(n).cdata(:,:,3);
        end
        clear v
        vinfo.mmread.cache.is_valid = true;
        vinfo.mmread.cache.f_start = 0;  
        vinfo.mmread.cache.f_end   = vinfo.n_frames-1;
      else
        vinfo.mmread.cache.data  = [];
        vinfo.mmread.cache.is_valid = false; % is cache valid?
        vinfo.mmread.cache.f_start = 0;  % first frame in cache
        vinfo.mmread.cache.f_end   = 0;  % last frame (may be < cache size)
      end
      
      % sanity check: make sure that number of frames is reasonable
      try 
          tmpvidobj = VideoReader(filename);      
          if vinfo.n_frames/tmpvidobj.NumberOfFrames > 1.5
              vinfo = rmfield(vinfo,'mmread');
              % use vidobj instead
              vinfo.type = 'vidobj';
              vinfo.vidobj = tmpvidobj;
              % store number of frames
              vinfo.n_frames = vinfo.vidobj.NumberOfFrames;
              % store frame size
              vinfo.sx = vinfo.vidobj.Height;
              vinfo.sy = vinfo.vidobj.Width;
              vinfo.sz = 1;
              
              % FPS and duration
              vinfo.fps = vinfo.vidobj.FrameRate;
              vinfo.duration = vinfo.n_frames / vinfo.fps;
          end
      catch
          %disp('Warning: Video not readable by VideoReader, using mmread instead.')
      end
   else
      error([filename ' does not specify a video directory or file']);
   end
end
