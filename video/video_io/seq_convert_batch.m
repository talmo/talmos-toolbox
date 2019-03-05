% Batch convert videos to seq file format.
%
%    seq_convert_batch(dir_dst, dir_src, extn, [seq_info], [frame_step])
%
% where [] denotes an optional parameter and:
%
%    dir_dst    - destination directory for seq files
%    dir_src    - source directory
%    extn       - filter/extension of files to convert (ie '*.fmf')
%    seq_info   - seq info struct
%    frame_step - step between frames for subsampling video (default 1)
function seq_convert_batch(dir_dst, dir_src, extn, seq_info, frame_step)
   % default arguments
   if (nargin < 4), seq_info = []; end
   if ((nargin < 5) || isempty(frame_step)), frame_step = 1; end
   % determine speedup factor
   if (frame_step == 1)
      sf = '';
   else
      sf = ['-' num2str(frame_step) 'x'];
   end
   % get files to convert
   filenames = dir(fullfile(dir_src,extn));
   filenames = { filenames.name };
   n_files = numel(filenames);
   for f = 1:n_files
      % get source/destination files
      fname = filenames{f};
      [pathstr name e] = fileparts(fname);
      fname_src = fullfile(dir_src, fname);
      fname_dst = fullfile(dir_dst, [name sf '.seq']);
      % display status
      disp([fname_src ' -> ' fname_dst]);
      % check if destination already exits
      if (exist(fname_dst,'file'))
         % skip conversion
         disp([fname_dst ' exists, skipping conversion']);
      else
         % open file, assemble frame range
         vinfo = video_open(fname_src);
         fr.start = 0;
         fr.limit = vinfo.n_frames;
         fr.step  = frame_step;
         % convert
         seq_convert(fname_dst, vinfo, fr, seq_info);
      end
   end
end
