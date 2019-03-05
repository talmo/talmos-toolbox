% This is an example of creating a simple animation with plotg by changing
% the values of the points at each iteration.
%
% Author: Siamak G. Faal
%         sghorbanifaal@wpi.edu
%         http://users.wpi.edu/~sghorbanifaal/index.html
% Date: September 16, 2017

clc; clear; close all;

% Define the x,y and z coordinates of the points
t = 0:0.1:10;
x = (cos(pi/5*t)+2).*cos(0.4*pi*t);
y = (cos(pi/5*t)+2).*sin(0.4*pi*t);
z = sin(pi/5*t);

% Set v to hold the values of each coordinate
v = linspace(0,10,length(x));

% Create figure and axes environments, set axes color to be black
h = figure(); colormap(hot); axes('Color','k'); hold on

% Change the view of the axes
view(40,72);

% Create a plotg object with x,y and z vectors and set line width to 5
g = plotg('XData',x,'YData',y,'ZData',z,'LineWidth',5);

while(ishandle(h))  % While the figure is open
    v = circshift(v,[0 1]);     % Circulate the values in v
    set(g,'CData',v);   % set CData of g (the handle of the plotg object 
                        % to be equal to new point values (v).
    drawnow();  % Update figures
end