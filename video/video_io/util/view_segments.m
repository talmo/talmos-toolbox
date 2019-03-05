% View segmentation.
function view_segments(im, S, fh)
   % default figure
   if (nargin < 3), fh = 1; end
   % select segments
   f = gcf;
   while (true)
      % display segmentation
      disp_segments(im, S, fh);
      % select a segment
      figure(fh);
      [sx sy] = size(S.seg);
      [x y button] = ginput_range([sx sy]);
      % check if done
      if (button == 2), break; end
      % get segment id
      id = S.seg(x,y);
      % display neighboring segments
      neighbor_list = S.graph{id};
      contour_list  = S.graph_contours{id};
      nn = length(neighbor_list);
      for n = 1:nn
         % get current neighbor and contour between
         idn = neighbor_list(n);
         contour = contour_list{n};
         % redraw segmentation
         disp_segments(im, S, fh);
         % draw neighbor connection and contour
         figure(fh);
         hold on;
         plot(S.seg_centers.ys([id idn]), S.seg_centers.xs([id idn]), 'r-');
         [contour_xs contour_ys] = ind2sub([sx sy], contour);
         plot(contour_ys, contour_xs, 'g.');
         hold off;
         pause;
      end
   end
   figure(f);
end

% Display the segmentation graph in the specified figure.
function disp_segments(im, S, fh)
   % default figure
   if (nargin < 3), fh = 1; end
   f = gcf;
   % display image with boundaries overlaid
   figure(fh);
   image(0.5.*(im + repmat(S.boundary,[1 1 size(im,3)])));
   axis image;
   axis off;
   % display segment centers
   hold on;
   plot(S.seg_centers.ys, S.seg_centers.xs, 'r.');
   hold off;
   figure(f);
end
