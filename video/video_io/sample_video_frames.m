% Sample video frames uniformly without replacement from the specified file.
%
%    sample_video_frames(fname, outdir, n_samp)
function sample_video_frames(fname, outdir, n_samp)
   v = video_open(fname);
   mkdir(outdir);
   mkdir([outdir '_ann']);
   f_nums = randperm(v.n_frames);
   f_nums = f_nums(1:n_samp) - 1;
   for n = 1:n_samp
      f_num = f_nums(n);
      f_name = num2str(f_num,'%07d');
      im = video_read_frame(v,f_num);
      imwrite(im,[outdir filesep f_name '.png']);
      system(['touch ' outdir '_ann' filesep f_name '.png.txt']);
   end
end
