function imnstacksc(varargin)
%IMNSTACKSC Scaled N stack image viewer.
% Usage:
%   imnstacksc(S1, S2, S3, ...)
%   imnstacksc(S) % multi-channel stack => size(S,3) > 1
%   imnstacksc(_, cmap)
%
% See also: imstacksc

% Check for colomap argument
narginchk(1, inf);
cmap = 'parula';
if nargin > 1 && ischar(varargin{end})
    cmap = varargin{end};
    varargin(end) = [];
end

% Validate
S = varargin;
S = cf(@validate_stack, S);

% Check if we have a single stack with multiple channels
if numel(S) == 1 && size(S{1}, 3) > 1
    S = arr2cell(S{1}, 3);
end

% Check for number of frames
numFrames = unique(cellfun(@(x) size(x,4), S));
if numel(numFrames) > 1; error('Stacks must all have the same number of frames.'); end

% Initialize graphics
fig = figure('KeyPressFcn', @KeyPressCB);

% Figure out subplots
N = numel(S);
p = numSubplots(N);

% Draw each stack's initial image
for i = 1:N
    ax(i) = subplot(p(1),p(2),i);
    clims = double(alims(S{i}));
    img(i) = imagesc(S{i}(:,:,:,1), clims);
    colorbar('Ticks', clims);
    colormap(cmap)
    axis equal
    axis tight
end

h_title = title(ax(1), '');

replot(1);

    function KeyPressCB(~, evt)
    isShift = ismember('shift', evt.Modifier);
    switch evt.Key
        case 'leftarrow'
            replot(fig.UserData.idx - 1 + isShift * -9);
        case 'rightarrow'
            replot(fig.UserData.idx + 1 + isShift * 9);
%         case 'uparrow'
%             adjustY(h, -(1 + isShift * 10));
%         case 'downarrow'
%             adjustY(h, 1 + isShift * 10);
    end
    end
    function replot(idx)
        idx = mod(idx-1,numFrames)+1;
        for j = 1:N
            img(j).CData = S{j}(:,:,:,idx);
        end
        
        fig.UserData.idx = idx;
        h_title.String = sprintf('%d/%d', idx, numFrames);
    end

end

