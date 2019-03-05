% Link points together into a chain starting from the reference point.  
% At each step, add the point closest to the last element added.
%
%    [idx] = point_chain(x,y,xs,ys)
%
% where:
%    (x,y)   - starting reference point
%    (xs,ys) - coordinates of points to link
%
% returns:
%    idx     - index vector giving order in which points are linked
function idx = point_chain(x,y,xs,ys)
   n_points = numel(xs);
   idx = zeros([n_points 1]);
   ids = (1:n_points).';
   for n = 1:n_points
      % compute distance from reference
      dx = xs - x;
      dy = ys - y;
      dist_sq = dx.*dx + dy.*dy;
      % pick closest point
      [dmin ind] = min(dist_sq);
      % update index vector
      idx(n) = ids(ind);
      % update reference
      x = xs(ind);
      y = ys(ind);
      % update set of remaining points
      xs(ind) = [];
      ys(ind) = [];
      ids(ind) = [];
   end
end
