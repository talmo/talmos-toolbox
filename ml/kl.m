function D = kl(p, q)
%KL Computes the Kullback-Leibler divergence between distributions p(x) and q(x).
% Usage:
%   D = kl(p, q)

assert(numel(p) == numel(q))

% Normalize
p = p(:) ./ sum(p);
q = q(:) ./ sum(q);

% KL(p||q)
D = sum(p .* log2(p + eps) - p .* log2(q + eps));

end

