function g = imageGraph3(sz,conn)
%imageGraph3  Graph of all 3-D image pixels
%
%   g = imageGraph3(sz)
%   g = imageGraph3(sz,conn)
%
%   g = imageGraph(sz) computes the 26-connected pixel neighbor graph
%   for a 3-D image with size specified by the three-element vector
%   sz.
%
%   g = imageGraph3(sz,conn) computes the pixel neighbor graph using the
%   specified connectivity.
%
%   EXAMPLES
%
%   Compute and the pixel neighbor graph for a 64-by-64-by-64 image.
%
%       g = imageGraph3([64 64 64])
%
%   Compute and plot the 6-connected pixel neighbor graph for a
%   64-by-64-by-64 image.
%
%       g6 = imageGraph3([64 64 64],6)
%
%   MORE ABOUT CONNECTIVITY
%
%   3-D connectivity can be specified by the numbers 6, 18, or 26.
%   6-connected voxels share a common face. 18-connected voxels
%   share a common face or edge. 26-connected voxels share a common
%   face, edge, or vertex.
%
%   3-D connectivity can also be specified by a odd-size 3-D array
%   of 0s and 1s that is symmetric through its center element.
%
%   Note that a 3-D connectivity array can be larger than
%   3-by-3-by-3, which is a more general form than is allowed in
%   Image Processing Toolbox functions.
%
%   See also plotImageGraph, imageGraph, binaryImageGraph,
%   binaryImageGraph3, adjacentRegionsGraph.

%   Copyright 2015 The MathWorks, Inc.
%   Steve Eddins

requireR2015b

% Input argument parsing and validation.
validateattributes(sz,{'numeric'},{'row','integer','nonnegative',...
   'numel',3});

default_conn = 26;
if nargin < 2
   conn = default_conn;
end
conn = checkConnectivity(conn);

g = binaryImageGraph3(true(sz),conn);
