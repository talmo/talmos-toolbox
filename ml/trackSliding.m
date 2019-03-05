function matches = trackSliding(feats, seed, windowSize)
%TRACKSLIDING Tracks the seed points across a timeseries of features.
% Usage:
%   matches = trackSliding(feats, seed)
%   matches = trackSliding(feats, seed, windowSize)
%
% Args:
%   feats: NxD(x1)xT features of N points with D dimensions at T timepoints
%   seed: Mx1 vector of indices of initial points in the first timepoint
%         or MxD matrix of the seed features
%   windowSize: number of timesteps in the past to use in window (default = 30)
%
% Returns:
%   matches: MxT indices of the tracked points at each timestep

% Parse inputs
feats = validate_stack(feats);
if nargin < 3 || isempty(windowSize); windowSize = 30; end

% Find seed points in the first timestep if indices not given
if ~isvector(seed)
    seed = findClosestPoint(seed, feats(:,:,:,1));
end

% Initialize
M = numel(seed);
[N, D, ~, T] = size(feats);
matches = NaN(M,T);

% First timestep is just the seed points
matches(:,1) = seed;

% Track each point
for i = 1:M
    matches_i = matches(i,:);
    for t = 2:T
        % Get the window of previous matches
        window_idx = max(1, t - windowSize):(t - 1);
        [x,y] = meshgrid(window_idx, 1:D);
        feats_idx = sub2ind(size(feats), matches_i(x(:))', y(:), ones(numel(x),1), x(:));
%         match_idx = matches(i, window_idx);
%         feats_idx = sub2ind(size(feats), repmat(match_idx,1,D), repelem(1:D,numel(match_idx)), ones(1,D*numel(match_idx)), repmat(window_idx,1,D));
        window = reshape(feats(feats_idx),D,[])';
        
        % Search for the closest point in the current timestep to each
        % point in the window
        closest = findClosestPoint(window, feats(:,:,:,t));
        
        % Keep the most often occurring point
        matches_i(t) = mode(closest);
    end
    matches(i,:) = matches_i;
end


end

