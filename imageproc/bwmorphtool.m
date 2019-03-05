function bwmorphtool(BW)
%BWMORPHTOOL Interactively apply bwmorph operations to a binary image.
% Usage:
%   bwmorphtool
%
% See also: bwmorph

BW0 = BW;
cc0 = countcc(BW0);

operations = {'bothat', 'branchpoints', 'bridge', 'clean', 'close', 'diag', 'dilate', 'endpoints', 'erode', 'fatten', 'fill', 'hbreak', 'majority', 'perim4', 'perim8', 'open', 'remove', 'shrink', 'skeleton', 'spur', 'thicken', 'thin', 'tophat'};
operation = operations{1};

fig = figure('Color','w');
gui = uix.VBox('Parent',fig);

ax = axes(gui);
img = imagesc(BW,[0 3]);
axis image
colormap gray

controls = uix.HBox('Parent',gui,'Spacing',10,'Padding',10);
gui.Heights = [-1 45];

uicontrol(controls, 'Style','text', 'String','Operation:');
ops = uicontrol(controls, 'Style','popupmenu','String',operations, 'Callback',@(~,~)morph(false));
apply = uicontrol(controls, 'Style','pushbutton', 'String','Apply', 'Callback',@(~,~)morph(true));
uicontrol(controls, 'Style','text', 'String','N:');
N = uicontrol(controls, 'Style','edit', 'String','1', 'Callback',@(~,~)morph(true));
uicontrol(controls, 'Style','pushbutton', 'String','+', 'Callback',@(~,~)changeN(+1));
uicontrol(controls, 'Style','pushbutton', 'String','-', 'Callback',@(~,~)changeN(-1));
uicontrol(controls, 'Style','pushbutton', 'String','Reset', 'Callback',@(~,~)reset());
numCC = uicontrol(controls, 'Style','text', 'String',sprintf('CCs: %d', cc0));

controls.Widths = [75 -3 75 50 -1 30 30 75 40];

    function morph(update)
        operation = ops.String{ops.Value};
        n = str2double(N.String);
        BW2 = bwmorph(BW,operation,n);
        numCC.String = sprintf('CCs: %d/%d', countcc(BW2), cc0);
        
        if update
            BW = BW2;
            apply.Enable = 'off';
        else
            apply.Enable = 'on';
        end
        
        I = uint8(BW0);
        I(BW) = 2;
        I(BW2) = 3;
        
%         img.CData = BW0.*1 + BW.*2 + BW2.*4;
        img.CData = I;
        
        drawnow;
    end
    function changeN(dN)
        n = str2double(N.String);
        N.String = num2str(n+dN);
        morph(false);
    end
    function reset()
        img.CData = BW0;
        BW = BW0;
    end

end

