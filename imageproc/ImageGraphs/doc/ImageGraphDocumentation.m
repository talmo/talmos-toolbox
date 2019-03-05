%% Image Graph Documentation
% These prototype MATLAB functions create and plot graphs from
% images based on neighbor relationships between pixels. You must
% have MATLAB R2015b to use them.
%
% <matlab:doc('imageGraph') |imageGraph|> creates a graph
% representing the neighbor relationships for every pixel in an
% image with a specified size. |imageGraph3| does the same thing for
% a 3-D image array.
%
% <matlab:doc('binaryImageGraph') |binaryImageGraph|> creates a
% graph representing the neighbor relationships for every foreground
% pixel in a binary image. |binaryImageGraph3| creates a graph from
% a 3-D binary image array.
%
% <matlab:doc('plotImageGraph') |plotImageGraph|> plots a graph
% created by |imageGraph| or |binaryImageGraph| with the graph nodes
% arranged on a pixel grid.
%
% <matlab:doc('adjacentRegionGraph') |adjacentRegionGraph|> creates
% a graph from a label matrix defining image regions. The graph
% represents the region adjacency relationships.
%
%% Example: Image graph with 8-connected pixels
%
% Create a graph for a 480-by-640 image with 8-connected pixels.

g = imageGraph([480 640],8)

%%
% Graph nodes contain the x-coordinate, y-coordinate, and linear
% index of the corresponding image pixels.

g.Nodes(1:5,:)

%%
% Plot the image graph using |plotImageGraph|.

plotImageGraph(g)
axis([100 110 220 230])

%% Example: Image graph with 4-connected pixels
%
% Create a graph for a 480-by-640 image with 4-connected pixels.

g = imageGraph([480 640],4)

%%

plotImageGraph(g)
axis([100 110 220 230])

%% Example: Image graph with special connectivity
%
% Use a 3-by-3 connectivity matrix to create an image graph with
% 6-connected pixels. Each pixel is connected to its north,
% northeast, east, south, southwest, and west neighbors.

conn = [0 1 1; 1 1 1; 1 1 0];
g = imageGraph([480 640],conn);
plotImageGraph(g)
axis([100 110 220 230])

%% Example: Binary image graph
%
% Create a graph whose nodes are the foreground pixels of the binary
% image text.png (a sample image that is included with the Image
% Processing Toolbox).

bw = imread('text.png');
imshow(bw)
title('Original image')

%%
g = binaryImageGraph(bw);
figure
plotImageGraph(g)
axis([60 85 30 45])

%% Region Graphs
% A label matrix defines a set of regions based on each unique
% element value in the matrix. For example, suppose you had the
% following label matrix:

L = [10 10 3 4.5 4.5; 10 10 3 4.5 4.5; 20 20 3 15 15; 20 20 3 15 15]

%%
% This label matrix defines 5 regions:
%
% * A 2-by-2 region in the upper left labeled with the value 10. 
% * A 2-by-2 region in the lower left labeled with the value 20.
% * A one-pixel-wide vertical region in the middle labeled with the
% value 3.
% * A 2-by-2 region in the upper right labeled with the value 4.5.
% * A 2-by-2 region at the lower right labeled with the value 15.
%
% The function |adjacentRegionsGraph| returns a graph with the same
% number of nodes as labeled regions. Edges in the graph indicate
% pairs of adjacent regions.
%
%% Example: Region graph
%
% Compute an adjacent regions graph. Plot the graph, highlighting
% the nodes connected to the label 15.

g = adjacentRegionsGraph(L)

%%
% The graph nodes contain the region labels.

g.Nodes

%%
% The graph edges contain the labels for each adjacent region pair.

g.Edges

%%
% Plot the graph, capturing the GraphPlot object as an output
% argument.

gp = plot(g,'NodeLabel',g.Nodes.Label)

%%
% Find the neighbors of the region labeled 15.

node_num = find(g.Nodes.Label == 15);
neighbors_15 = neighbors(g,node_num);
highlight(gp,node_num,neighbors_15)

% Copyright 2015 The MathWorks, Inc.