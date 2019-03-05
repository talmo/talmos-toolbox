% Hungarian matching with leftover greedy assignment.
%
%    [m_forward m_backward] = match_hungarian(cost_mx, th)
%
% where:
%
%    cost_mx    - pairwise matching costs bewteen sets A and B
%                 (m x n matrix where m = |A| and n = |B|)
%    th         - maximum cost match allowed (default = inf)
%
% returns:
%
%    m_foward   - length m vector mapping items in set A to set B
%    m_backward - length n vector mapping items in set B to set A
%                 (in each case, a zero indicates an item is not matched)
%
% Perform an initial matching using the Hungarian algorithm with outlier cost
% specified by threshold th.  Modify these initial matches by allowing any 
% unpaired items (initially assigned as outliers) to also match to a currently
% paired item (so matching is no longer one-to-one) if the cost of the 
% additional match is less than th.
function [m_forward m_backward] = match_hungarian(cost_mx, th)
   % get number of items in each set
   [m n] = size(cost_mx);
   % set default cost threshold if not specified
   if (nargin < 2), th = inf; end
   % treat infinite threshold as twice highest cost in matrix
   if (isinf(th))
      th = 2.*max(cost_mx(:));
   end
   % introduce nodes for outliers, create new cost matrix
   s = m+n;
   c_mx = th.*ones([s s]);
   c_mx(1:m,1:n) = cost_mx;
   % solve assignment problem using hungarian algorithm
   [assign total_cost] = munkres(c_mx);
   % create match vectors
   m_forward  = zeros([m 1]);
   m_backward = zeros([n 1]);
   for i = 1:m
      % get match
      j = assign(i);
      % record if match is valid
      if ((j > 0) && (j <= n))
         m_forward(i)  = j;
         m_backward(j) = i;
      end
   end
   % perform additional greedy matching
   [m_forward m_backward] = match_greedy(cost_mx, th, m_forward, m_backward);
end
