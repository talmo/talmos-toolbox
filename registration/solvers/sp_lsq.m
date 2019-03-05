function [rel_tforms, avg_prior_error, avg_post_error] = sp_lsq(matches, fixed_tile)
%SP_LSQ Sparse Least Squares alignment solver.
% Usage:
%   tforms = sp_lsq(matches)
%   [rel_tforms, avg_prior_error, avg_post_error] = sp_lsq(matches, fixed_tile)

if nargin < 2
    fixed_tile = 1;
end

% Build sparse matrices
[A, B] = matchmat(matches.A, matches.B);
% AT = BT
% (B - A)T = 0
% CT = 0
C = B - A;

% DT = F
j = 3 * fixed_tile - 2:3 * fixed_tile; % columns of fixed tile
F = -C(:, j); % fixed tile block column
D = C(:, setdiff(1:size(C, 2), j)); % C without F

% Solve with mldivide
T = D \ F;

% Format into cell array of affine2d objects
Ts = mat2cell(full(T(:, 1:2)), repmat(3, length(T) / 3, 1));
rel_tforms = [{affine2d()}; cellfun(@(t) affine2d(t), Ts, 'UniformOutput', false)];

% Calculate error before alignment
res_prior = full(D * repmat(eye(3), length(T) / 3, 1) - F);
avg_prior_error = rownorm2(res_prior(:, 1:2));

% Calculate residual and average error
res_post = full(D * T - F);
avg_post_error = rownorm2(res_post(:, 1:2));

end

