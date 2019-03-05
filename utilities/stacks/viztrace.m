function h_fig = viztrace(S, trace, window, extra_callbacks, varargin)
%VIZTRACE 

if nargin < 3 || isempty(window); window = [-30, 30]; end
if nargin < 4; extra_callbacks = []; end

cbs = {@drawTrace};
if ~isempty(extra_callbacks) && ~iscell(extra_callbacks)
    extra_callbacks = {extra_callbacks};
end
cbs = [cbs horz(extra_callbacks)];

fig = imstacksc(S,cbs,'clear',true,varargin{:});

fig.UserData.ax = subplot(1,2,1,fig.UserData.ax);
fig.UserData.trace_ax = subplot(1,2,2);
hold on

if isvector(trace)
    plot(trace)
else
    if size(trace,1) > 30
        [hl,hb] = plot95perc(trace, 'r', 'transparency', 0.3);
        ylim(ylim())
        legend([hl,hb], 'Median', '95th Percentile', 'AutoUpdate', 'off')
    else
        h = plot(trace','-','Color',[0.8 0.8 0.8]);
        h = h(1);
        h(2) = plot(median(trace), '-', 'LineWidth', 2);
        h(3) = plot(mean(trace), '-', 'LineWidth', 2);
        legend(h, 'Traces', 'Median', 'Mean', 'AutoUpdate', 'off')
        
        ylim(alims(trace))
    end
end
grid on
fig.UserData.vbar = plot([1 1], ylim(), 'r-');

fig.Position(3) = fig.Position(3) * 2;

drawTrace(fig,1)

if fig.UserData.params.tight; tightfig; end

if nargout > 0
    h_fig = fig;
end

    function drawTrace(fig, idx)
        if isfield(fig.UserData, 'trace_ax')
            fig.UserData.vbar.XData = [idx idx];
            xlim(fig.UserData.trace_ax, window + idx)
        end
    end

end

