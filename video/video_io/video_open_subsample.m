% Open a video to be automatically subsampled or smoothed when read.
% Return a handle to the video.
%
%    vinfo = video_open_subsample(weights, filename, ...)
%
% where:
%    weights         - odd length vector of weights specifying the weighted 
%                      combination of frames used to replace the central frame
%    filenae, ...    - arguments to video_open(...)
%
% Example: video_open_subsample([0.5 1 0.5], filename, ...) smooths each frame 
% by mixing in the previous and subsequent frames.
function vinfo = video_open_subsample(weights, filename, varargin)
   % open the video normally
   v = video_open(filename, varargin{:});
   % store source and type
   vinfo.filename = filename;
   vinfo.type = 'subsample';
   % store subsampling parameters
   vinfo.subsample.vinfo   = v;
   vinfo.subsample.weights = weights;
   % store number of frames
   vinfo.n_frames = max(v.n_frames - (numel(weights) - 1), 0);
   % store frame size
   vinfo.sx = v.sx;
   vinfo.sy = v.sy;
   vinfo.sz = v.sz;
end
