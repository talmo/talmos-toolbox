function gp_out = plotImageGraph(g)
%plotImageGraph  Plot 2-D image graph.
%
%   plotImageGraph(g)
%   gp = plotImageGraph(g)
%
%   plotImageGraph(g) plots an image graph as created by imageGraph
%   or binaryImageGraph.
%
%   gp = plotImageGraph(g) plots the graph and returns a GraphPlot
%   object.
%
%   EXAMPLE
%
%   Compute and plot the pixel neighbor graph for the foreground
%   pixels in the image text.png (a sample image shipped with the
%   Image Processing Toolbox).
%
%       bw = imread('text.png');
%       g = binaryImageGraph(bw);
%       plotImageGraph(g)
%       % Zoom in
%       axis([60 85 30 45])
%
%   See also imageGraph, binaryImageGraph, GraphPlot.

%   Copyright 2015 The MathWorks, Inc.
%   Steve Eddins

requireR2015b

graph_has_z = any(strcmp(g.Nodes.Properties.VariableNames,'z'));
if graph_has_z
   error('se:ig:ThreeDPlotting',...
      'Plotting 3-D image graphs not supported.');
end

gp = plot(g,'XData',g.Nodes.x,'YData',g.Nodes.y,...
   'Marker','s','MarkerSize',5);
ax = ancestor(gp,'axes');
axis(ax,'ij');
axis(ax,'equal');

if nargout > 0
   gp_out = gp;
end

