% Clear frame cache associated with an open video.
%
%   video_clear_cache(vinfo)
%
% where vinfo is an open video being read via mmread clears any frames in the 
% associated read cache.
function video_clear_cache(vinfo)
   % get name of object in caller
   vinfo_name = inputname(1);
   if (isempty(vinfo_name))
      error('video_clear_cache must be passed a named variable (reference)');
   end
   % check video type
   if (strcmp(vinfo.type,'vlist'))
      % clear cache of subvideos
      n_files = numel(vinfo.vlist);
      for n = 1:n_files
         vtemp = vlist{n};
         video_clear_cache(vtemp);
         vinfo.vlist{n} = vtemp;
      end
   elseif (strcmp(vinfo.type,'mmread'))
      % clear cache, mark as invalid
      vinfo.mmread.cache.data = [];
      vinfo.mmread.cache.is_valid = false;
      vinfo.mmread.cache.f_start = 0;
      vinfo.mmread.cache.f_end   = 0;
   end
   % update vinfo object in caller
   assignin('caller', vinfo_name, vinfo);
end
