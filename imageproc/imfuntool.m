function imfuntool(I, fun)
%IMFUNTOOL Interactively apply a function to a binary image.
% Usage:
%   imfuntool(I, fun)
%
% fun must follow the syntax: Iout = fun(I, param1, param2, ...)
%
% See also: bwmorphtool

I0 = I;
% cc0 = countcc(I0);

numParams = nargin(fun) - 1; % first param is image
fun_str = char(fun);

fig = figure('Color','w');
gui = uix.VBox('Parent',fig);

ax = axes(gui);
img = imagesc(I);
axis image
colormap gray
title(fun_str)

controls = uix.HBox('Parent',gui,'Spacing',10,'Padding',10);
gui.Heights = [-1 45];

uicontrol(controls, 'Style','text', 'String','Params:');
param_controls = af(@(~)uicontrol(controls, 'Style','edit', 'Callback', @(~,~)morph(false)),1:numParams);
apply = uicontrol(controls, 'Style','pushbutton', 'String','Apply', 'Callback',@(~,~)morph(true));
uicontrol(controls, 'Style','pushbutton', 'String','Reset', 'Callback',@(~,~)reset());
% numCC = uicontrol(controls, 'Style','text', 'String',sprintf('CCs: %d', cc0));

controls.Widths = [75 -1 .* ones(1,numParams) 50 50];

    function morph(update)
%         param = str2double(param_ui.String);
        params = getParams();
        try
            I2 = fun(I,params{:});
            title(fun_str)
        catch ME
            titlef('%s: %s', fun_str, ME.message)
            return
        end
%         numCC.String = sprintf('CCs: %d/%d', countcc(I2), cc0);
        
        if update
            I = I2;
            apply.Enable = 'off';
        else
            apply.Enable = 'on';
        end
        
%         I = uint8(BW0);
%         I(BW) = 2;
%         I(BW2) = 3;
        
%         img.CData = BW0.*1 + BW.*2 + BW2.*4;
        img.CData = I2;
        
        drawnow;
    end
    function params = getParams()
        params = cf(@(x)str2double(x.String),param_controls);
    end
%     function changeN()
%         n = str2double(N.String);
%         N.String = num2str(n+dN);
%         morph(false);
%     end
    function reset()
        img.CData = I0;
        I = I0;
    end

end

