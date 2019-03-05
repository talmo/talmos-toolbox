% Matching with both cost and fertility (size) constraints.
%
%    [m_forward m_backward] = match(cost_mx, cost_th, fa, fb, df_th)
%
% where:
%
%    cost_mx    - pairwise matching costs bewteen sets A and B
%                 (m x n matrix where m = |A| and n = |B|)
%    cost_th    - maximum cost match allowed (default = 0)
%    cost_diff_th - minimum cost ambiguity allowed (default = inf)
%    fa         - length m vector of fertilities for set A (default = all ones)
%    fb         - length n vector of fertilities for set B (default = all ones)
%    df_th      - threshold on remaining fertility for item to be duplicated
%                 (default = 1)
%
% returns:
%
%    m_foward   - length m vector mapping items in set A to set B
%    m_backward - length n vector mapping items in set B to set A
%                 (in each case, a zero indicates an item is not matched)
%
% Perform an initial matching using the Hungarian algorithm with greedy 
% assignment of outliers (via the match_hungarian function).  If outliers 
% exist, duplicate items with the highest remaining fertility (if allowed) 
% and recompute the matching.  Repeat until no outliers or no unused fertility
% remains.
function [m_forward m_backward] = match(cost_mx, cost_th, cost_diff_th, min_diff_th, fa, fb, df_th)
   % get number of items in each set
   [m n] = size(cost_mx);
   if (n==0 || m==0)
      m_forward = [];
      m_backward = [];
      return
   end

   % set default cost threshold if not specified
   if (nargin < 2), cost_th = inf; end
   % set default ambiguity threshold if not specified
   if (nargin < 3), cost_diff_th = 0; end
   % set default minimum difference threshold if not specified
   if (nargin < 4), min_diff_th = 0; end
   % set default fertilities 
   if (nargin < 5), fa = ones([m 1]); end
   if (nargin < 6), fb = ones([n 1]); end
   % set default fertility threshold
   if (nargin < 7), df_th = 1; end   
   
   % if cost matrix reveals too much ambiguity, return zeros (no solution)
   if size(cost_mx,2) > 1                                                     
       sum_diff_best = 0;  
       min_diff_best_ratio = inf;
       min_diff_best = inf;
       for i=1:size(cost_mx,1)                                       
           costs = sort(abs(cost_mx(i,:)));                           
           sum_diff_best = sum_diff_best + costs(2)/max(0.001,costs(1));   
           min_diff_best_ratio = min(min_diff_best_ratio,costs(2)/max(0.001,costs(1)));
           min_diff_best = min(min_diff_best,costs(2)-costs(1));
       end                                                           
       sum_diff_best = sum_diff_best/i;                              
       if sum_diff_best < cost_diff_th || min_diff_best < min_diff_th % 0 if everything stitched 
       %if min_diff_best_ratio < cost_diff_th || min_diff_best < 10%cost_diff_th
           m_forward = zeros(1,size(cost_mx,1));                            
           m_backward = zeros(1,size(cost_mx,2));               
           return                                                  
       end
   end
%    if numel(cost_mx) > 1 &&  mean(abs(diff(cost_mx'))) < 10
%       m_forward = zeros(1,size(cost_mx,1));
%       m_backward = zeros(1,size(cost_mx,2));
%       return
%    end

   % initialize replication counts
   rep_a = ones([m 1]);
   rep_b = ones([n 1]);
   % matching/fertility update loop
   flag = true;
   while (flag)
      % initialize cost matrix for problem with replications
      m_rep = sum(rep_a);
      n_rep = sum(rep_b);
      c_mx = zeros([m_rep n_rep]);
      % fill in original cost submatrix, disallow matches between duplicates
      c_mx(1:m,1:n)             = cost_mx;
      c_mx((m+1):end,(n+1):end) = inf;
      % build map of replicated index -> original index (for set A)
      idx_a = [(1:m).'; zeros([(m_rep-m) 1])];
      ia = m+1;
      for k = 1:m
         rc = rep_a(k) - 1;
         if (rc > 0)
            idx_a(ia:(ia+rc-1)) = k;
            ia = ia + rc;
         end
      end
      % build map of replicated index -> original index (for set B)
      idx_b = [(1:n).'; zeros([(n_rep-n) 1])];
      ib = n+1;
      for j = 1:n
         rc = rep_b(j) - 1;
         if (rc > 0)
            idx_b(ib:(ib+rc-1)) = j;
            ib = ib + rc;
         end
      end
      % fill in entires for duplicates in cost matrix
      c_mx(1:m,(n+1):end) = c_mx(1:m,idx_b((n+1):end));
      c_mx((m+1):end,1:n) = c_mx(idx_a((m+1):end),1:n);
      % perform matching
      [m_forward m_backward] = match_hungarian(c_mx, cost_th);
      % compute predicted fertility and use flags from one-to-one matches
      f_used_a = zeros([m 1]); rep_used_a = zeros([m 1]);
      f_used_b = zeros([n 1]); rep_used_b = zeros([n 1]);
      for k = 1:m_rep
         j = m_forward(k);
         if ((j ~= 0) && (m_backward(j) == k))
            % get original indices
            k_orig = idx_a(k);
            j_orig = idx_b(j);
            % record used fertility
            f_used_a(k_orig) = f_used_a(k_orig) + fb(j_orig);
            f_used_b(j_orig) = f_used_b(j_orig) + fa(k_orig);
            % record used replications
            rep_used_a(k_orig) = rep_used_a(k_orig) + 1;
            rep_used_b(j_orig) = rep_used_b(j_orig) + 1;
         end
      end
      % compute remaining fertility
      f_extra_a = fa - f_used_a; f_extra_a = f_extra_a.*(f_extra_a > 0);
      f_extra_b = fb - f_used_b; f_extra_b = f_extra_b.*(f_extra_b > 0);
      % compute remaining replications
      rep_extra_a = rep_a - rep_used_a;
      rep_extra_b = rep_b - rep_used_b;
      % remove outlier (non one-to-one) matches
      for k = 1:m_rep
         j = m_forward(k);
         if ((j == 0) || (m_backward(j) ~= k))
            m_forward(k) = 0;
         end
      end
      for j = 1:n_rep
         k = m_backward(j);
         if ((k == 0) || (m_forward(k) ~= j))
            m_backward(j) = 0;
         end
      end
      % translate matches back to original items
      idx_a_lookup = [0; idx_a];
      idx_b_lookup = [0; idx_b];
      m_forward  = idx_b_lookup(m_forward + 1);
      m_backward = idx_a_lookup(m_backward + 1);
      % remove entries for duplicates
      m_forward  = m_forward(1:m);
      m_backward = m_backward(1:n);
      % check for incoming outliers
      has_outlier_a = any(m_backward == 0);
      has_outlier_b = any(m_forward == 0);
      % find saturated items with highest unused fertility
      [val_a ind_a] = max(f_extra_a.*(rep_extra_a == 0));
      [val_b ind_b] = max(f_extra_b.*(rep_extra_b == 0));
      % increase fertility if allowed
      flag = false;
      if ((has_outlier_a) && (val_a >= df_th))
         rep_a(ind_a) = rep_a(ind_a) + 1;
         flag = true;
      end
      if ((has_outlier_b) && (val_b >= df_th))
         rep_b(ind_b) = rep_b(ind_b) + 1;
         flag = true;
      end
   end
end
