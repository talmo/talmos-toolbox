function vizsegperim(S, BWs, varargin)
%VIZSEGPERIM

colors = 'rbgwc';
if ~iscell(BWs); BWs = {BWs}; end

imstacksc(S, @drawSeg);

% hold on
% for i = 1:numel(BWs)
%     h_names(i) = plot(NaN(1,2),'-','LineWidth',2,'Color',colors(i));
% end
% legend(h_names, names{:})

    function drawSeg(fig,idx)
        img = fig.UserData.img;
        for j = 1:numel(BWs)
            img.CData = imoverlay(img.CData, bwperim(BWs{j}(:,:,:,idx)),colors(j));
%             if ~isempty(handles{j}); delete([handles{j}{:}]); end
%             bounds = bwboundaries(BWs{j}(:,:,:,idx));
%             handles{j} = cf(@(b)draw_poly(fliplr(b),[colors(j) '0.5']),bounds);
        end
    end

end

