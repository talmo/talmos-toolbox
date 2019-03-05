function g = adjacentRegionsGraph(L,conn)
%adjacentRegionsGraph  Graph of adjacent regions from label matrix.
%
%   g = adjacentRegionsGraph(L)
%   g = adjacentRegionsGraph(L,conn)
%
%   g = adjacentRegionsGraph(L) computes a graph containing
%   adjacency relationships corresponding to the label matrix L. The
%   Nodes table of the graph contains a Label variable contains the
%   original label values from L. The adjacency geometry is
%   8-connected if L is 2-D and 26-connected if L is 3-D.
%
%   g = adjacentRegionsGraph(L,conn) uses the specified
%   connectivity.
%
%   EXAMPLES
%
%   Find all the pairs of 4-connected adjacent regions for a sample
%   label matrix.
%
%       L = repelem([5 1 27; 2 18 9; -5 50 40],3,3)
%
%       g = adjacentRegionsGraph(L,4);
%       region_pairs = g.Nodes.Label(g.Edges.EndNodes)
%
%   Compute the 4-connected adjacent regions graph for a sample
%   label matrix. Plot the graph and highlight the regions adjacent
%   to the region with the label 40.
%
%      L = repelem([5 1 27; 2 18 9; -5 50 40],3,3)
%
%      g = adjacentRegionsGraph(L,4);
%      gp = plot(g,'NodeLabel',g.Nodes.Label)
%
%      % Which graph node corresponds to the region labeled 40?
%      node_40 = find(g.Nodes.Label == 40)
%
%      % Find and highlight neighboring regions.
%      highlight(gp,node_40,neighbors(g,node_40))
%
%   MORE ABOUT CONNECTIVITY
%
%   Two-dimensional connectivity can be specified by the number 4 or
%   the number 8, specifying the traditional definitions of
%   4-connected or 8-connected pixel neighbors.
%
%   Two-dimensional connectivity can also be specified by a odd-size
%   matrix of 0s and 1s that is symmetric through its center
%   element. For example, the following connectivity matrix says
%   that a pixel is a connected neighbor of the pixel just above it
%   and the pixel just below it:
%
%       conn = [ ...
%                0  1  0
%                0  1  0
%                0  1  0  ]
%
%   And the following connectivity matrix says that a pixel is
%   a connected neighbor of the pixels to the upper right and lower
%   left.
%
%       conn = [ ...
%                0  0  1
%                0  1  0
%                1  0  0  ]
%
%   3-D connectivity can be specified by the numbers 6, 18, or 26.
%   6-connected voxels share a common face. 18-connected voxels
%   share a common face or edge. 26-connected voxels share a common
%   face, edge, or vertex.
%
%   3-D connectivity can also be specified by a odd-size 3-D array
%   of 0s and 1s that is symmetric through its center element.

%   Copyright 2015 The MathWorks, Inc.
%   Steve Eddins

requireR2015b

% Input argument parsing and validation.
validateattributes(L,{'numeric','logical'},{'3d'});

if ismatrix(L)
   default_conn = 8;
else
   default_conn = 26;
end
if nargin < 2
   conn = default_conn;
end
conn = checkConnectivity(conn);

% We can improve efficiency by restricting our attention to pixels
% that are known to be different from at least one of their
% neighbors.
mask = (L ~= imdilate(L,conn)) | (L ~= imerode(L,conn));
mask_graph = binaryImageGraph(mask,conn);

% Find pairs of pixel values corresponding to neighbor pairs.
connected_values = L(mask_graph.Nodes.PixelIndex(mask_graph.Edges.EndNodes));

% Remove pairs of the same value.
connected_values(connected_values(:,1) == connected_values(:,2),:) = [];

% Remove duplicate value pairs.
connected_values = unique(sort(connected_values,2),'rows');

% Use unique to compute a node numbering for all the different
% values in the list of value pairs.
a = connected_values(:);
[c,~,ic] = unique(a);
edges = reshape(ic,size(connected_values));

% Make the graph. Record the pixel values as auxiliary information
% in the graph's node table. Record the adjacent pixel value pairs
% as auxiliary information in the graph's edge table.
g = graph(edges(:,1),edges(:,2));
g.Nodes.Label = c;
g.Edges.Labels = g.Nodes.Label(g.Edges.EndNodes);
