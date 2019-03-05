function [Y, loss] = process_tsne(X, labels, varargin)
%PROCESS_TSNE Wrapper for new builtin tsne.

if nargin < 2 || isempty(labels)
    labels = vert(1:length(X));
end

defaults = {
    'Algorithm', 'barneshut'
    'Distance', 'euclidean'
    'NumDimensions', 2
    'NumPCAComponents', 0 % PCA preprocessing
    'InitialY', [] % initialization
    'Perplexity', 30 % 5 - 50 -- effective number of local neighbors
    'Exaggeration', 4 % spaces out clusters -- decrease if KL decreases during lying (iter < 99)
    'LearnRate', 500 % 100 - 1000
    'Theta', 0.5 % 0 - 1.0 -- higher = faster, but less accurate
    'Standardize', 0 % zscore data columns
    'NumPrint', 5 % iterations between printing/updating
    'options', struct('MaxIter',500,'TolFun',1e-10,...
                      'OutputFcn',@(optimValues,state)outfun(optimValues,state,labels))
    'Verbose', 2 % 0 - 2
    }';

params = struct2nameval(parse_params(varargin, defaults));

stic;
[Y, loss] = tsne(X,params{:});
stocf('Finished computing t-SNE')

function stop = outfun(optimValues,state,labels)
persistent h kllog iters stopnow hloss1 hloss2 hy hdens htxt
switch state
    case 'init'
        stopnow = false;
        kllog = [];
        iters = [];
        h = figure('Pos',[200, 150, 1000, 800]);
        figclosekey
        
        uicontrol('Style','pushbutton','String','Stop','Position',...
            [10 10 50 20],'Callback',@stopme);
        subplot(2,2,[3 4])
        hloss1 = plot(NaN,NaN); hold on
        hloss2 = plot(NaN,NaN);
        xlabel('Iterations')
        ylabel('Loss and Gradient')
        legend('Divergence','log(norm(Gradient))')
%         title('Divergence and log(norm(gradient))')

        subplot(2,2,1)
%         cm = viridis(max(labels));
        cm = jet(max(labels));
        hy = scatter(NaN(size(labels)),NaN(size(labels)),4,labels,'filled','CData',cm(labels,:));
        
        axis equal fill %xy %image %equal %tight
        graygrid
        title('Embedding')

        subplot(2,2,2)
        hdens = imagesc(zeros(75));
        axis image xy %xy equal %tight
        colorbar
        colormap(viridis())
        hold on
        htxt = title('BW:');
%         htxt = text(0,1,'asd','Color','w','Units','normalized',...
%             'HorizontalAlignment','left','VerticalAlignment','top',...
%             'FontSize',12,'FontWeight','bold');
        drawnow
        
    case 'iter'
        kllog = [kllog;optimValues.fval,log(norm(optimValues.grad))];
        assignin('base','history',kllog)
        iters = [iters; optimValues.iteration];
        if length(iters) > 1
            hloss1.XData = iters;
            hloss1.YData = kllog(:,1);
            
            hloss2.XData = iters;
            hloss2.YData = kllog(:,2);
            
            hy.XData = optimValues.Y(:,1);
            hy.YData = optimValues.Y(:,2);
            
            [density,x,y,bw] = compute_density(optimValues.Y);
            hdens.CData = density;
            hdens.XData = x;
            hdens.YData = y;
            
            htxt.String = sprintf('BW: %s',mat2str(bw,3));
            
            drawnow
        end
    case 'done'
        % Finish tasks
end
stop = stopnow;

    function stopme(~,~)
        stopnow = true;
    end
    
    function [density,xv,yv,bw] = compute_density(Y,n)
        if nargin<2; n = 100; end
%         xv = linspace(min(Y(:,1)),max(Y(:,1)),n);
%         yv = linspace(min(Y(:,2)),max(Y(:,2)),n);
        gv = linspace(min(Y(:)),max(Y(:)),n);
        xv = gv; yv = gv;
        [xq,yq] = meshgrid(xv,yv);
        [density,~,bw] = ksdensity(Y,[xq(:) yq(:)]);
        density = reshape(density,size(xq));
    end

end


end
