% Return assigments and parameters for 1-D gaussian mixture model
function [assign probs means vars] = gmm_1d(data, n_comp, max_iter)
   % initialize assigments and parameters
   n_data = numel(data);
   if (n_comp > n_data), n_comp = n_data; end
   data = reshape(data,[1 n_data]);
   assign = zeros([1 n_data]);
   means = zeros([n_comp 1]);
   vars  = ones([n_comp 1]);
   probs = zeros([n_comp n_data]);
   [vals inds] = sort(data);
   assign(inds) = round(((0:(n_data-1))./(n_data-1+(n_data==1))).*(n_comp-1))+1;
   % iterate
   for iter = 1:max_iter
      % recompute parameters
      for c = 1:n_comp
         inds = find(assign == c);
         vals = data(inds);
         if (~isempty(inds))
            means(c) = mean(vals);
            vars(c)  = var(vals);
         end
      end
      % update assignments
      x  = repmat(data,[n_comp 1]) - repmat(means,[1 n_data]);
      s2 = repmat(vars,[1 n_data]);
      probs = 1./sqrt(2.*pi.*s2).*exp(-0.5.*x.*x./s2);
      [pmax assign_new] = max(probs,[],1);
      % check if assignments changed
      if (all(assign_new==assign))
         break;
      else
         assign = assign_new;
      end
   end
   % extract unique components
   [c_ids i j] = unique(assign);
   means = means(c_ids);
   vars  = vars(c_ids);
   probs = probs(c_ids,:);
   ids = 1:numel(c_ids);
   assign = ids(j);
   % sort components by mean
   [means inds] = sort(means);
   vars  = vars(inds);
   probs = probs(inds,:);
   [junk inds_map] = sort(inds);
   assign = inds_map(assign);
end
