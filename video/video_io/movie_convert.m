% GUI for movie format conversion
function movie_convert
   % get file list to convert
   [filename pathname filterindex] = uigetfile( ...
      {'*.avi','AVI Videos (*.avi)'; ...
       '*.fmf','FMF Videos (*.fmf)'; ...
       '*.seq','SEQ Videos (*.seq)'}, ...
      'Select Videos to Convert', 'MultiSelect', 'on' ...
   );
   % check that selection was made
   if (filterindex == 0), return; end
   % ask about target file format
   if (filterindex == 1) 
      format = questdlg( ...
         'What file format do you want to convert to?', ...
         'Select Output File Format', ...
         'fmf', 'seq', 'fmf' ...
      );
   else
      % convert fmfs, seqs to avi
      format = 'avi';
   end
   % check whether to run batch or single conversion
   if (iscell(filename))
      % run batch conversion
      n_files = numel(filename);
      for n = 1:n_files
         % get current filename
         [pathstr name ext] = fileparts(filename{n});
         % assemble input/output filenames
         fname_in  = fullfile(pathname,[name ext]);
         fname_out = fullfile(pathname,[name '.' format]);
         % convert video
         if (strcmp(format,'avi'))
            avi_convert(fname_in, fname_out);
         else
            vid_convert(fname_in, fname_out, format);
         end
      end
   else
      % run single conversion
      [pathstr name ext] = fileparts(filename);
      % assemble input/output filenames
      fname_in  = fullfile(pathname,[name ext]);
      fname_out = fullfile(pathname,[name '.' format]);
      % convert video
      if (strcmp(format,'avi'))
         avi_convert(fname_in, fname_out);
      else
         vid_convert(fname_in, fname_out, format);
      end
   end
end
