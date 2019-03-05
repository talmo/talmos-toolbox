function imstackof(S, Vx, Vy, scale, roi)
%IMSTACKOF Visualize optical flow.

% if isa(Vx, 'opticalFlow')
%     of = Vx;
% else
%     of = stackfun(@(v) opticalFlow(v(:,:,1), v(:,:,2)), cat(3, Vx, Vy));
% end
% params = {'DecimationFactor', [1 1], 'ScaleFactor', 1};

if nargin < 3; scale = 1; end
if nargin < 4; roi = []; end

V = cat(3, Vx, Vy);


doTrace = ~isempty(roi);
if doTrace
    roi_ctr = [roi(1) + 0.5*roi(3), roi(2) + 0.5*roi(4)];
    pos = zeros(size(V,4), 2);
    pos(1,:) = roi_ctr;
%     [X, Y] = meshgrid(1:size(S,2), 1:size(S,1));
%     for i = 2:size(V,4)
%         dX = interp2(X,Y,V(:,:,1,i-1), pos(i-1,1), pos(i-1,2));
%         dY = interp2(X,Y,V(:,:,2,i-1), pos(i-1,1), pos(i-1,2));
%         
%         pos(i, :) = pos(i-1, :) + [dX dY];
%     end
    V_roi = reshape(stackroi(V,roi),[],2,size(V,4));
    V_roi(V_roi == 0) = NaN;
    
    V_med = squeeze(nanmean(V_roi));
%     V_med = squeeze(nanmedian(V_roi));
    V_med(isnan(V_med)) = 0;
    
    offsets = cumsum(V_med, 2)';
    pos = bsxadd(offsets, roi_ctr);
end


imstacksc(S, [], [], @drawFlow)

if doTrace
    hold on
    h_ctr = plot(roi_ctr(1), roi_ctr(2), 'r+');
    h_trace = plot(NaN, NaN, 'r-');
    
    drawRect(roi, 'r')
end

    function drawFlow(fig, idx)
        % Look for previous quiver plot
        isQuiver = arrayfun(@(x) isa(x, 'matlab.graphics.chart.primitive.Quiver'), ...
            fig.CurrentAxes.Children);
        
        % Clear those
        delete(fig.CurrentAxes.Children(isQuiver))
        
        % Plot new
        hold on
        vizdisplacement(V(:,:,:,idx), scale, 'g')
        
        % Update roi trace
        if doTrace
            h_ctr.XData = pos(idx,1);
            h_ctr.YData = pos(idx,2);
            
            trace = pos(max(1, idx - 30):idx, :);
            h_trace.XData = trace(:,1);
            h_trace.YData = trace(:,2);
        end
    end


end

