function [A, B] = matchmat(matchesA, matchesB)
%MATCHMAT Creates sparse match matrices.
sec_nums = unique([unique(matchesA.section); unique(matchesB.section)]);
num_secs = length(sec_nums);
tile_nums = arrayfun(@(s) unique([unique(matchesA.tile(matchesA.section == s)); unique(matchesB.tile(matchesB.section == s))]), sec_nums, 'UniformOutput', false);
num_tiles = cellfun(@(t) length(t), tile_nums);
cum_num_tiles = cumsum(num_tiles) - num_tiles(1);

total_tiles = cum_num_tiles(end) + num_tiles(1);
num_matches = height(matchesA);

% Build index arrays
Ja = zeros(height(matchesA), 1);
Jb = zeros(height(matchesB), 1);
for s = 1:num_secs
    tile_idx = zeros(1, length(tile_nums{s}));
    for t = min(tile_nums{s}):max(tile_nums{s})
        idx = find(tile_nums{s} == t, 1);
        if ~isempty(idx)
            tile_idx(t) = idx;
        end
    end
    
    Ia = matchesA.section == sec_nums(s);
    Ja(Ia) = cum_num_tiles(s) * 3 + (tile_idx(matchesA.tile(Ia)) - 1) * 3 + 1;
    
    Ib = matchesB.section == sec_nums(s);
    Jb(Ib) = cum_num_tiles(s) * 3 + (tile_idx(matchesB.tile(Ib)) - 1) * 3 + 1;
end

Ia = repmat((1:num_matches)', 3, 1);
Ib = repmat((1:num_matches)', 3, 1);

Ja = [Ja; Ja + 1; Ja + 2];
Jb = [Jb; Jb + 1; Jb + 2];

% Points
Sa = [double(matchesA.global_points(:)); ones(num_matches, 1)];
Sb = [double(matchesB.global_points(:)); ones(num_matches, 1)];

% Sparse matrix sizes
m = num_matches;
n = total_tiles * 3;
nnzAB = num_matches * 3;

% Create sparse matrices
A = sparse(Ia, Ja, Sa, m, n, nnzAB);
B = sparse(Ib, Jb, Sb, m, n, nnzAB);
%b = Sb;
%gamma = sparse([Ib; Ia], [Jb; Ja], [Sb; Sa], m, n, nnzGamma);

end

