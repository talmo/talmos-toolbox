% Create or initialize a video output directory.
%
%    vinfo = video_create(vinfo, {'label1', 'label2', ... })
%
%    vinfo = video_create('dir', n_frames, {'label1', 'label2', ...})
%
% creates and initializes subdirectories 'label1', 'label2', ..., under the 
% main video directory given in vinfo or as the string 'dir'.  In the latter
% case, n_frames specifies the length of the video.
function vinfo = video_create(arg1, arg2, arg3)
   % chech arguments
   if (nargin == 2)
      vinfo = arg1;
      labels = arg2;
      if (~strcmp(vinfo.type,'dir'))
         error('vinfo must specify a directory');
      end
   elseif (nargin == 3)
      % initialize vinfo
      vinfo.filename = absolute_path(arg1);
      vinfo.type = 'dir';
      vinfo.dir.subdirs = {};
      vinfo.dir.subdir_size = 1000;
      vinfo.dir.frame_extn = '.png';
      vinfo.dir.name_len = 6;
      % create main directory
      if (~exist(vinfo.filename,'dir'))
         mkdir(vinfo.filename);
      end
      % get n_frames, labels
      vinfo.n_frames = arg2;
      labels = arg3;
      % fill subdirectory list
      n_subdirs = ceil(vinfo.n_frames/vinfo.dir.subdir_size);
      vinfo.dir.subdirs = cell([1 n_subdirs]);
      for n = 1:n_subdirs
         vinfo.dir.subdirs{n} = num2str( ...
            (n-1)*(vinfo.dir.subdir_size), ...
            ['%0' num2str(vinfo.dir.name_len), 'd'] ...
         );
      end
   else
      error('incorrect number of input arguments');
   end
   % create subdirectories under labels
   for l = 1:numel(labels)
      % create label directory
      label = labels{l};
      label_dir = fullfile(vinfo.filename, label);
      if (~exist(label_dir,'dir'))
         mkdir(label_dir);
      end
      % create subdirectories
      for n = 1:numel(vinfo.dir.subdirs)
         label_subdir = fullfile(label_dir, vinfo.dir.subdirs{n});
         if (~exist(label_subdir,'dir'))
            mkdir(label_subdir);
         end
      end
   end
end
