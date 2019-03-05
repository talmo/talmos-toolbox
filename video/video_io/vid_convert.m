% Convert a video from an mmread format to a .seq or .fmf
%
%   vid_convert(filename_in,filename_out,format)
% 
% where format is 'seq' or 'fmf'.
function vid_convert(filename_in, filename_out, format)
   % open input file
   vinfo = video_open(filename_in);
   % initialize status
   status.format   = format;
   status.n_frames = vinfo.n_frames;
   % set name to display in status
   [pathstr name ext] = fileparts(filename_out);
   status.fname = [name ext];
   % initialize writer
   if (strcmp(format,'seq'))
      % set seq info
      seq_info.width   = vinfo.sy;
      seq_info.height  = vinfo.sx;
      seq_info.fps     = round(vinfo.mmread.rate);
      if (seq_info.fps <= 0)
         seq_info.fps  = 25;
      end
      seq_info.quality = 80;
      seq_info.codec   = 'monojpg';
      % create writer
      status.seq.sw = seqIo(filename_out, 'writer', seq_info);
   elseif (strcmp(format,'fmf'))
      % write header
      status.fmf.fp = fmf_write_header( ...
         filename_out, ...
         28, ...
         1, ...
         vinfo.sx, ...
         vinfo.sy, ...
         8 + (vinfo.sx).*(vinfo.sy), ...
         vinfo.n_frames, ...
         'MONO8' ...
      );
   else
      error('invalid format specified');
   end
   % store frame rate
   status.fps = round(vinfo.mmread.rate);
   if (status.fps <= 0)
      status.fps  = 25;
   end
   % create waitbar
   status.h_waitbar = waitbar_create( ...
      ['Writing Frame'], ...
      [status.fname], ...
      0, (status.n_frames-1) ...
   );
   % set data
   setappdata(0,'vid_convert',status);
   % switch directories
   wd = pwd;
   path = fileparts(mfilename('fullpath'));
   cd(fullfile(path,'mmread'));
   % process video inline
   try
      mmread(filename_in,[],[],false,false,'vid_convert_frame');
   catch
   end
   % clear data
   rmappdata(0,'vid_convert');
   % finish writer
   if (strcmp(format,'seq'))
      % close writer
      status.seq.sw.close();
      % generate seek file
      sr = seqIo(filename_out, 'reader');
      sr.close();
   elseif (strcmp(format,'fmf'))
      % close file
      fclose(status.fmf.fp);
   else
      error('invalid format specified');
   end
   % restore working directory
   cd(wd);
   % close waitbar
   waitbar_close(status.h_waitbar);
   % close input file
   video_close(vinfo);
end
