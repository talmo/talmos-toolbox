% Greedy matching.
%
%    [m_forward m_backward] = match_greedy(cost_mx, th)
%    [m_forward m_backward] = match_greedy(cost_mx, th, m_forward, m_backward)
%
% where:
%    
%    cost_mx    - pairwise matching costs bewteen sets A and B
%                 (m x n matrix where m = |A| and n = |B|)
%    th         - maximum cost match allowed (default = inf)
%    m_forward  - existing forward matches to preserve (optional)
%    m_backward - existing backward matches to preserve (optional)
%
% returns:
%
%    m_foward   - length m vector mapping items in set A to set B
%    m_backward - length n vector mapping items in set B to set A
%                 (in each case, a zero indicates an item is not matched)
%
% Set correspondences between items by greedily picking the lowest cost match
% from the cost matrix.  Only matches costing less than the given threshold are
% permitted.  If given, preserve initial matches specified by m_forward and
% m_backward while matching currently unassigned items in a greedy fashion.
function [m_forward m_backward] = ...
   match_greedy(cost_mx, th, m_forward, m_backward)
   % get number of items in each set
   [m n] = size(cost_mx);
   % set default cost threshold if not specified
   if (nargin < 2), th = inf; end
   % initialize match vectors if not specified
   if (nargin < 3), m_forward  = zeros([m 1]); end
   if (nargin < 4), m_backward = zeros([n 1]); end
   % sort matches by cost
   [costs inds] = sort(cost_mx(:));
   [is js] = ind2sub([m n],inds);
   % perform greedy matching
   for k = 1:(m*n)
      % get indices to match and cost
      i = is(k);
      j = js(k);
      c = costs(k);
      % check if match allowed
      m_ok = (c <= th);
      % update matches
      m_forward(i)  = m_forward(i)  + m_ok.*(m_forward(i)==0).*j;
      m_backward(j) = m_backward(j) + m_ok.*(m_backward(j)==0).*i;
   end
end
