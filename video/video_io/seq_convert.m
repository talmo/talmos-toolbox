% Convert a video into an seq file.
%
%    seq_convert('filename', vinfo, [frame_range], [seq_info], [h_waitbar])
%
% where [] denotes an optional parameter and:
%
%    'filename'   - name of seq file to write
%
%    vinfo        - handle to video
%
%    frame_range. - range of video frames to write to seq file (default all)
%       start     - first frame (default 0)
%       limit     - limit frame (default total # frames)
%       step      - step between frames (default 1)
%
%    seq_info     - seq info struct
%
%    h_waitbar    - waitbar handle (default none, otherwise create if < 0)
%
% NOTE: This function requires Piotr's image toolbox to be in the Matlab path.
function seq_convert(filename, vinfo, frame_range, seq_info, h_waitbar)
   % default seq options
   seq_info_default.width    = vinfo.sy;
   seq_info_default.height   = vinfo.sx;
   seq_info_default.fps      = 25;
   seq_info_default.quality  = 100;
   if (vinfo.sz == 1)
      seq_info_default.codec = 'monojpg';
   else
      seq_info_default.codec = 'jpg';
   end
   % default arguments
   if ((nargin < 3) || isempty(frame_range))
      frame_range.start = 0;
      frame_range.limit = vinfo.n_frames;
      frame_range.step  = 1;
   end
   if ((nargin < 4) || isempty(seq_info))
      seq_info = seq_info_default;
   end
   if (nargin < 5), h_waitbar = []; end
   % set unspecified seq options
   seq_info = set_defaults(seq_info, seq_info_default);
   % create writer
   sw = seqIo(filename, 'writer', seq_info);
   % create waitbar
   if ((~isempty(h_waitbar)) && (h_waitbar < 0))
      h_waitbar = waitbar_create( ...
         ['Writing Frame'], ...
         [filename], ...
         (frame_range.start), (frame_range.limit-1) ...
      );
   end
   % compute number of processing steps
   if (frame_range.limit <= frame_range.start)
      n_steps = 0;
   else
      n_steps = ...
         1 + floor((frame_range.limit-frame_range.start-1)./frame_range.step);
   end
   % compute waitbar update interval
   update_int = min(ceil(0.01.*n_steps),100);
   % write seq file 
   frames_complete = 0;
   
   use_vinfo = 1;
   try 
       video_read_frame(vinfo,0);
   catch
       use_vinfo = 0;
       vidobj = VideoReader(vinfo.filename);
   end
   for id = (frame_range.start):(frame_range.step):(frame_range.limit-1)
      % get frame
      if use_vinfo
        im = video_read_frame(vinfo, id);
      else
        tmp = read(vidobj,id+1);
        im = double(tmp(:,:,3))/255;
      end
      % write frame
      sw.addframe(uint8(im.*255));
      % update display
      if (mod(frames_complete,update_int) == 0)
         % update status message
         msg = [ ...
            '\r' ...
            'Writing ' filename ': Frame ' ...
            num2str(id) ' of ' num2str(frame_range.limit-1) ...
            ' [' num2str(100.*(frames_complete+1)./n_steps,'%3.0f') '%%]' ...
         ];
         fprintf(msg);
         % update waitbar
         if (~isempty(h_waitbar))
            is_canceled = waitbar_update(h_waitbar, ...
               ['Writing Frame'], ...
               [filename], ...
               (id), (frame_range.limit-1), (frames_complete+1)./n_steps ...
            );
            drawnow;
            % check if cancelled
            if (is_canceled), break; end
         end
      end
      frames_complete = frames_complete + 1;
   end
   % update message
   fprintf('\n');
   % close writer
   sw.close();
   % generate seek file
   sr = seqIo(filename, 'reader');
   sr.close();
   % close waitbar
   if (~isempty(h_waitbar)), waitbar_close(h_waitbar); end
end
