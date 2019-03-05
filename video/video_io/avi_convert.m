% Convert video to avi format.
function avi_convert(fname_in, fname_out)
   % load file
   vinfo = video_open(fname_in);
   % initialize avifile
   cmap = repmat(linspace(0,1,256)',[1,3]);
   aviobj = avifile(fname_out,'fps',30,'compression','None','colormap',cmap);
   % initialize frame range
   frame_range.start = 0;
   frame_range.limit = vinfo.n_frames;
   frame_range.step  = 1;
   % initialize waitbar
   h_waitbar = waitbar_create( ...
      ['Writing Frame'], ...
      [fname_out], ...
      (frame_range.start), (frame_range.limit-1) ...
   );
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
   for id = (frame_range.start):(frame_range.step):(frame_range.limit-1)
      % get frame
      im = video_read_frame(vinfo, id);
      im = uint8(im.*255);
      % add to avi
      aviobj = addframe(aviobj,im);
      % update display
      if (mod(frames_complete,update_int) == 0)
         % update waitbar
         if (~isempty(h_waitbar))
            is_canceled = waitbar_update(h_waitbar, ...
               ['Writing Frame'], ...
               [fname_out], ...
               (id), (frame_range.limit-1), (frames_complete+1)./n_steps ...
            );
            drawnow;
            % check if cancelled
            if (is_canceled), break; end
         end
      end
      frames_complete = frames_complete + 1;
   end
   % close avi file 
   aviobj = close(aviobj);
   % close waitbar
   if (~isempty(h_waitbar)), waitbar_close(h_waitbar); end
end
