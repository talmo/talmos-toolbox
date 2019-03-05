function ufmf_plot_stats(ufmf)
%UFMF_PLOT_STATS Plots some metrics for a UFMF video.
% Usage:
%   ufmf_plot_stats
%   ufmf_plot_stats(ufmf)
% 
% See also: ufmf_stats

% Browse for file
if nargin < 1
    ufmf = ufmf_browse();
end

% Get the stats structure
if ~isstruct(ufmf) || (isstruct(ufmf) && isfield(ufmf, 'fid'))
    ufmf = ufmf_stats(ufmf);
end

% Plot
figure

% Number of boxes
subplot(2, 1, 1)
bar(ufmf.bg.num_boxes), hold on
for i = 1:ufmf.num_keyframes
    plot(repmat(ufmf.bg.keyframes(i), 2, 1), [0; max(ufmf.bg.num_boxes)], 'r--')
        
end
axis tight
grid on
xlabel('Frame Number'), ylabel('Number of foreground boxes')

% dT
subplot(2, 1, 2)
bar(ufmf.bg.dT)
xlabel('Keyframes')
ylabel('\DeltaT (secs)', 'interpreter', 'tex')
axis tight

end

