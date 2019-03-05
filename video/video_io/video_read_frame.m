% Read requested frame from the video.
%
%    im = video_read_frame(vinfo, id)
%
% returns frame id of the requested video as an image.
%
%    im = video_read_frame(vinfo, id, 'label')
%
% where vinfo refers to a video stored in directory form, reads the 
% frame from the 'label' subdirectory.  'label' defaults to 'frames'.
%
% Reading .seq files requires Piotr's Matlab toolbox to be installed.
%
% id is the 0-based index of the frame
function im = video_read_frame(vinfo, id, label)
   % check that frame is in range
   if ((id < 0) || (id >= vinfo.n_frames))
      error(['cannot read out of range frame ' ...
             num2str(id) ' of ' num2str(vinfo.n_frames)]);
   end
   % check type of video
   if (strcmp(vinfo.type,'vlist'))
      % convert id to position within subvideo
      frame_count = 0;
      v_num = 0;
      while (id >= frame_count)
         v_num = v_num + 1;
         frame_count = frame_count + vinfo.vlist{v_num}.n_frames;
      end
      v_id = id - (frame_count - vinfo.vlist{v_num}.n_frames);
      % get subvideo to read from 
      subvinfo = vinfo.vlist{v_num};
      % check if subvideo cache will be updated
      cache_update = ...
         strcmp(subvinfo.type,'mmread') && ...
         ~((subvinfo.mmread.cache.is_valid) && ...
           (subvinfo.mmread.cache.f_start <= v_id) && ...
           (v_id <= subvinfo.mmread.cache.f_end));
      % read frame from subvideo
      if (nargin < 3)
         im = video_read_frame(subvinfo, v_id);
      else
         im = video_read_frame(subvinfo, v_id, label);
      end
      % update vinfo object if cache was updated
      if (cache_update)
         % store updated subvideo cache
         vinfo.vlist{v_num} = subvinfo;
         % update vinfo object in caller
         vinfo_name = inputname(1);
         if (~isempty(vinfo_name))
            assignin('caller', vinfo_name, vinfo);
         else
            warning( ...
               ['could not update frame cache during video read - ' ...
                'this may negatively impact performance'] ...
            );
         end
      end
   elseif (strcmp(vinfo.type,'subsample'))
      % initialize frame
      im = zeros([vinfo.sx vinfo.sy vinfo.sz]);
      % get actual video handle
      subvinfo = vinfo.subsample.vinfo;
      % get frames to read from subvideo
      nw = numel(vinfo.subsample.weights);
      id_start = id;
      id_end   = id + nw - 1;
      % check if subvideo cache will be updated
      cache_update = ...
         strcmp(subvinfo.type,'mmread') && ...
         ~((subvinfo.mmread.cache.is_valid) && ...
           (subvinfo.mmread.cache.f_start <= id_start) && ...
           (id_end <= subvinfo.mmread.cache.f_end));
      % combine weighted frames
      id_curr = id;
      for w = 1:nw
         im = im + ...
              vinfo.subsample.weights(w) .* video_read_frame(subvinfo, id_curr);
         id_curr = id_curr + 1;
      end
      im = im ./ (sum(vinfo.subsample.weights) + eps);
      % update vinfo object if cache was updated
      if (cache_update)
         % store updated subvideo cache
         vinfo.subsample.vinfo = subvinfo;
         % update vinfo object in caller
         vinfo_name = inputname(1);
         if (~isempty(vinfo_name))
            assignin('caller', vinfo_name, vinfo);
         else
            warning( ...
               ['could not update frame cache during video read - ' ...
                'this may negatively impact performance'] ...
            );
         end
      end
   elseif (strcmp(vinfo.type,'dir'))
      % default label
      if (nargin < 3), label = 'frames'; end
      % assemble name of requested frame
      format_str = ['%0' num2str(vinfo.dir.name_len) 'd'];
      subdir_id = floor(id/vinfo.dir.subdir_size)*(vinfo.dir.subdir_size);
      subdir_id_str = num2str(subdir_id, format_str);
      id_str = num2str(id, format_str);
      fname = fullfile( ...
         vinfo.filename, label, subdir_id_str, [id_str vinfo.dir.frame_extn]);
      % read frame
      im = double(imread(fname))./255;
   elseif (strcmp(vinfo.type,'bin'))
      % seek to frame
      frm_size = (vinfo.sx).*(vinfo.sy).*(vinfo.sz);
      pos = id.*frm_size;
      fseek(vinfo.bin.fid, pos, 'bof');
      % read frame
      im = double(fread(vinfo.bin.fid, frm_size, 'uint8'))./255;
      im = reshape(im,[vinfo.sx vinfo.sy vinfo.sz]);
   elseif (strcmp(vinfo.type,'seq'))
      % read frame
      flag = vinfo.seq.sr.seek(id);
      if (~flag)
         error('unable to seek to specified frame in seq file');
      end
      im  = double(vinfo.seq.sr.getframe()) ./ ...
            ((2.^vinfo.seq.info.imageBitDepthReal)-1);
      % convert to grayscale if needed
      if (size(im,3) > vinfo.sz)
         im = rgb2gray(im);
      end
   elseif (strcmp(vinfo.type,'fmf'))
      % check fmf version
      if (vinfo.fmf.version == 1)
         % seek to frame
         frm_sz = prod(vinfo.fmf.framesize);
         pos = id * (vinfo.fmf.chunksize) + (vinfo.fmf.chunksize - frm_sz);
         fseek(vinfo.fmf.fid, vinfo.fmf.header_bytes + pos, 'bof');
         % read frame
         im = double(fread(vinfo.fmf.fid, frm_sz, 'uint8'))./255;
         im = reshape(im,[vinfo.sx vinfo.sy vinfo.sz]);
      elseif (vinfo.fmf.version == 3)
         % seek to frame
         frm_sz = prod(vinfo.fmf.framesize);
         pos = id * (vinfo.fmf.chunksize) + (vinfo.fmf.chunksize - frm_sz);
         fseek(vinfo.fmf.fid, vinfo.fmf.header_bytes + pos, 'bof');
         % read frame
         im = double(fread(vinfo.fmf.fid, frm_sz, 'uint8'))./255;
         im = permute(reshape(im,[vinfo.sz vinfo.sy vinfo.sx]),[3 2 1]);
      else
         error(['fmf is not version 1 or 3']);
      end
   elseif (strcmp(vinfo.type,'sbfmf'))
      % seek to frame
      fseek(vinfo.sbfmf.fid, vinfo.sbfmf.frame2file(id+1), 'bof');
      % read frame
      npixels = double(fread(vinfo.sbfmf.fid,1,'uint32'));
      stamp = fread(vinfo.sbfmf.fid,1,'double');
      idx = double(fread(vinfo.sbfmf.fid,npixels,'uint32'))+1;
      val = double(fread(vinfo.sbfmf.fid,npixels,'uint8'));
      % set values at indices
      im = vinfo.sbfmf.bgcenter;
      im(idx) = val;
      % rescale
      im = im./255;
   elseif (strcmp(vinfo.type,'ufmf'))
      im = ufmf_read_frame(vinfo.ufmf, id+1);
      im = double(im)/255;
   elseif (strcmp(vinfo.type,'vidobj'))
      im = read(vinfo.vidobj,id+1);
      im = double(im(:,:,1))/255;
   elseif (strcmp(vinfo.type,'mmread'))
      % check if frame is in cache
      if (~((vinfo.mmread.cache.is_valid) && ...
            (vinfo.mmread.cache.f_start <= id) && ...
              (id <= vinfo.mmread.cache.f_end)))
         % allocate cache if needed
         cache_size = vinfo.mmread.cache.cache_size;
         if (isempty(vinfo.mmread.cache.data))
            vinfo.mmread.cache.data = ...
               zeros([vinfo.sx vinfo.sy vinfo.sz cache_size]);
         end
         % set cache frame range
         f_start = id - (cache_size - floor(cache_size/2) - 1);
         f_end   = id + floor(cache_size/2);
         f_start = max(f_start, 0);
         f_end   = min(f_end, vinfo.n_frames-1);
         % compute time indices
         t_start = (f_start - 0.5)./(vinfo.mmread.rate);
         t_end   = (f_end + 0.5)./(vinfo.mmread.rate);
         % read video file
         vid = mmread(vinfo.filename, [], [t_start t_end]);
         % fill cache
         cache_size = numel(vid.frames);
         %cache_size = f_end - f_start + 1;
         for n = 1:cache_size
            vinfo.mmread.cache.data(:,:,:,n) = ...
               rgb2gray(double(vid.frames(n).cdata)./255);
         end
         % update cache status
         vinfo.mmread.cache.f_start  = f_start;
         vinfo.mmread.cache.f_end    = f_start+cache_size-1;%f_end;
         vinfo.mmread.cache.is_valid = true;
         % update vinfo object in caller
         vinfo_name = inputname(1);
         if (~isempty(vinfo_name))
            assignin('caller', vinfo_name, vinfo);
         else
            warning( ...
               ['could not update frame cache during video read - ' ...
                'this may negatively impact performance'] ...
            );
         end
      end
      % load from cache
      im = vinfo.mmread.cache.data(:,:,:,(id - vinfo.mmread.cache.f_start + 1));
      if isa(im,'uint8')
          im = double(im)/255;
      end
   elseif (strcmp(vinfo.type,'null'))
      % return empty frame
      im = zeros([vinfo.sx vinfo.sy vinfo.sz]);
   else
      error('unrecognized video type');
   end
end
