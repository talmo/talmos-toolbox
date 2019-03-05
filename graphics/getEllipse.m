function getEllipse(ell, color, ax, new_pos_cb)
%GETELLIPSE Interactively move an ellipse.
% Usage:
%   getEllipse(ell, color, ax, new_pos_cb)
% 
% Args:
%   ell: initial ellipse of the form: [x y a b theta]
%   color: line color of ellipse
%   ax: axes to draw on
%   new_pos_cb: callback for when ellipse is moved.
%               callback is invoked with the new ellipse: fun(new_ell)
% 
% See also: drawEllipse, getEllipsePoints

if nargin < 2 || isempty(color); color = 'r'; end
if nargin < 3 || isempty(ax); ax = gca; end
if nargin < 4; new_pos_cb = []; end

hold(ax,'on')

numAlphas = 60;
alphas = linspace(0,360,numAlphas);
perim = getEllipsePoints(ell,alphas);
h_ell = plot(perim(:,1),perim(:,2),'-','Color',color);

front = getEllipsePoints(ell,0);
h_front = impoint(ax,front);
h_front.addNewPositionCallback(@moveFront);
h_front.setColor(color);

back = getEllipsePoints(ell,180);
h_back = impoint(ax,back);
h_back.addNewPositionCallback(@moveBack);
h_back.setColor(color);

top = getEllipsePoints(ell,90);
h_top = impoint(ax,top);
h_top.addNewPositionCallback(@moveTop);
h_top.setColor(color);

bottom = getEllipsePoints(ell,270);
h_bottom = impoint(ax,bottom);
h_bottom.addNewPositionCallback(@moveBottom);
h_bottom.setColor(color);

major = createLine(back, front); % [x0 y0 dx dy]
minor = createLine(top, bottom); % [x0 y0 dx dy]

ctr = major(1:2) + 0.5.*major(3:4);
ctr_line = [ctr; front];
h_ctr_line = plotpts(ctr_line, '-', 'Color',color);

    function updateEll()
        major = createLine(back, front); % [x0 y0 dx dy]
        minor = createLine(top, bottom); % [x0 y0 dx dy]
        
        ctr = major(1:2) + 0.5.*major(3:4);
        a = distancePoints(front, back) / 2;
        b = distancePoints(top, bottom) / 2;
        theta = rad2deg(lineAngle(major));
        
        ell = [ctr a b theta];
        
        
        perim = getEllipsePoints(ell,alphas);
        h_ell.XData = perim(:,1);
        h_ell.YData = perim(:,2);
        
        ctr_line = [ctr; front];
        h_ctr_line.XData = ctr_line(:,1);
        h_ctr_line.YData = ctr_line(:,2);
        
        front = getEllipsePoints(ell,0);
        h_front.setPosition(front);
        back = getEllipsePoints(ell,180);
        h_back.setPosition(back);
        bottom = getEllipsePoints(ell,270);
        h_bottom.setPosition(bottom);
        top = getEllipsePoints(ell,90);
        h_top.setPosition(top);
        
        if ~isempty(new_pos_cb)
            new_pos_cb(ell);
        end
        
        drawnow;
    end
    function moveFront(new_pos)
        front = new_pos;
        updateEll();
    end
    function moveBack(new_pos)
        back = new_pos;
        updateEll();
    end
    function moveTop(new_pos)
        top = new_pos;
        updateEll();
    end
    function moveBottom(new_pos)
        bottom = new_pos;
        updateEll();
    end

end
