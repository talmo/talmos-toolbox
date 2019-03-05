function h_fig = edgestacktool(S, thresh)
%IMFUNTOOL Interactively apply a function to a binary image.
% Usage:
%   imfuntool(I, fun)
%
% fun must follow the syntax: Iout = fun(I, param1, param2, ...)
%
% See also: bwmorphtool

if nargin < 2; thresh = []; end

% S = stack2cell(S);
S = validate_stack(S);

[~, thresh] = edge(S(:,:,:,1), 'canny', thresh);
thresh0 = thresh;

BW = imtile(spf(@(x)edge(x,'canny',thresh),S));
T = imtile(S);

fig = figure('Color','w');
gui = uix.HBox('Parent',fig);

ax = axes(gui);
img = imshowpair(T, BW);

controls_low = uix.VBox('Parent',gui,'Spacing',10,'Padding',10);
controls_high = uix.VBox('Parent',gui,'Spacing',10,'Padding',10);
gui.Widths = [-1 60 60];

low_slider = uicontrol(controls_low, 'Style','slider', 'Value', thresh(1), 'Callback', @morph);
low_text = uicontrol(controls_low, 'Style','text', 'String', num2str(thresh(1)));
uicontrol(controls_low, 'Style', 'pushbutton', 'String', 'Reset', 'Callback', @resetCB)
controls_low.Heights = [-1 15 30];

high_slider = uicontrol(controls_high, 'Style','slider', 'Value', thresh(2), 'Callback', @morph);
high_text = uicontrol(controls_high, 'Style','text', 'String', num2str(thresh(2)));
uicontrol(controls_high, 'Style', 'pushbutton', 'String', 'Save', 'Callback', @saveCB)
controls_high.Heights = [-1 15 30];

if nargout > 0
    h_fig = fig;
end

    function morph(~,~)
        thresh = [low_slider.Value, high_slider.Value];
        low_text.String = num2str(thresh(1));
        high_text.String = num2str(thresh(2));
        try
%             BW = edge(I,'canny',thresh);
            BW = imtile(spf(@(x)edge(x,'canny',thresh),S));
            title('')
        catch ME
            titlef('Error: %s', ME.message)
            return
        end

        img.CData = imfuse(T, BW);
        
        drawnow;
    end
    function saveCB(~,~)
%         var_name = 'canny_thresh';
%         assignin('base', var_name, thresh)
        export2wsdlg({'Thresholds:'},{'canny_thresh'},{thresh})
%         printf('Saved to workspace: %s', var_name)
    end
    function resetCB(~,~)
        low_slider.Value = thresh0(1);
        high_slider.Value = thresh0(2);
        morph()
    end
end

