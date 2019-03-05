% Learn parameters for a Gaussian mixture model.
function model = gmm_em(data, K, max_iter, gamma)
   % default maximum number of iterations
   if (nargin < 3), max_iter = 10; end
   % get number of data points
   N = size(data,1);
   % get data dimension
   D = size(data,2);
   % initialize clusters
   [idx centroids] = kmeans(data, K, 'EmptyAction', 'singleton', 'Display', 'off');
   % shrink centroids if there's an unused cluster
   used = zeros([size(centroids,1) 1]);
   for n = 1:N
      used(idx(n)) = 1;
   end
   used_inds = find(used);
   centroids = centroids(used_inds,:);
   idx_adjust = cumsum(used==0);
   for n = 1:N
      idx(n) = idx(n) - idx_adjust(idx(n));
   end
   K = size(centroids,1);
   % initialize cluster membership indicator
   p = zeros([N K]);
   for n = 1:N
      p(n,idx(n)) = 1;
   end
   % initialize cluster means
   mu = centroids; % K by D matrix of means
   % initialize cluster covariances
   sigma = zeros([D D K]);
   for k = 1:K
      X = data - repmat(mu(k,:),[N 1]);
      pk = p(:,k);
      s = var(X,pk);
      sigma(:,:,k) = (1-gamma).*diag(s) + gamma.*eye(D);
   end
   % EM - loop
   for iter = 1:max_iter
      % E-step: re-evaluate cluster membership
      p_new = zeros([N K]);
      pn = sum(p,1)./N;
      for k = 1:K
         s = sigma(:,:,K);
         X = data - repmat(mu(k,:),[N 1]);
         p_new(:,k) = pn(k)./sqrt(det(s)).*exp(-0.5.*sum((X*inv(s)).*X,2));
      end
      p = p_new./repmat(sum(p_new,2),[1 K]);
      % M-step: recompute cluster means
      for k = 1:K
         mu(k,:) = sum(repmat(p(:,k),[1 D]).*data,1)./sum(p(:,k));
      end
      % M-step: recompute cluster covariances
      for k = 1:K
         X = data - repmat(mu(k,:),[N 1]);
         pk = p(:,k);
         s = var(X,pk);
         sigma(:,:,k) = (1-gamma).*diag(s) + gamma.*eye(D);
      end
   end
   % store model
   model.p     = p;
   model.pn    = sum(p,1)./N;
   model.mu    = mu;
   model.sigma = sigma;
end
