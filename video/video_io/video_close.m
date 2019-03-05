% Close an open video.
%
%    video_close(vinfo)
%
% closes any open files associated with the video specified by vinfo.
function video_close(vinfo)
   % check video type
   if (strcmp(vinfo.type,'vlist'))
      n_files = numel(vinfo.vlist);
      for n = 1:n_files
         video_close(vinfo.vlist{n});
      end
   elseif (strcmp(vinfo.type,'subsample'))
      video_close(vinfo.subsample.vinfo);
   elseif (strcmp(vinfo.type,'bin'))
      fclose(vinfo.bin.fid);
   elseif (strcmp(vinfo.type,'seq'))
      vinfo.seq.sr.close();
   elseif (strcmp(vinfo.type,'fmf'))
      fclose(vinfo.fmf.fid);
   elseif (strcmp(vinfo.type,'sbfmf'))
      fclose(vinfo.sbfmf.fid);
   end
end
