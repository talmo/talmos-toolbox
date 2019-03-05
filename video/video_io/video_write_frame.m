% Write frame to video output directory.
%
%    video_write_frame(im, vinfo, id, 'label')
%
% writes image im as frame id for the specified video under the subdirectory
% 'label'.
function video_write_frame(im, vinfo, id, label)
   % check that frame is in range
   if ((id < 0) || (id >= vinfo.n_frames))
      error(['cannot write out of range frame ' ...
             num2str(id) ' of ' num2str(vinfo.n_frames)]);
   end
   % check type of video
   if (strcmp(vinfo.type,'dir'))
      % assemble name of requested frame
      format_str = ['%0' num2str(vinfo.dir.name_len) 'd'];
      subdir_id = floor(id/vinfo.dir.subdir_size)*(vinfo.dir.subdir_size);
      subdir_id_str = num2str(subdir_id, format_str);
      id_str = num2str(id, format_str);
      fname = fullfile( ...
         vinfo.filename, label, subdir_id_str, [id_str vinfo.dir.frame_extn]);
      % write frame
      imwrite(im, fname);
   else
      error(['writing to video type ' vinfo.type ' not supported']);
   end
end
