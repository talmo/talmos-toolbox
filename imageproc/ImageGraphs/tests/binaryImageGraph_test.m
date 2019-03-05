function tests = binaryImageGraph_test

% Copyright 2015 The MathWorks, Inc.
% Steve Eddins

tests = functiontests(localfunctions);
end

function connectivity8_test(test_case)
% Test cases hand-checked.
bw = [0 0 0 0; 0 1 1 0; 0 1 0 0; 1 0 0 0];
[g,nodenums] = binaryImageGraph(bw,8);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,nodenums,[0 0 0 0; 0 2 4 0; 0 3 0 0; 1 0 0 0]);
verifyEqual(test_case,g.Nodes.x,[1 2 2 3]');
verifyEqual(test_case,g.Nodes.y,[4 2 3 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[4 6 7 10]');
verifyEqual(test_case,g.Edges.EndNodes,[1 3; 2 3; 2 4; 3 4]);
verifyEqual(test_case,g.Edges.Weight,[sqrt(2) 1 1 sqrt(2)]');
end

function connectivity4_test(test_case)
% Test cases hand-checked.
bw = [0 0 0 0; 0 1 1 0; 0 1 0 0; 1 0 0 0];
[g,nodenums] = binaryImageGraph(bw,4);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,nodenums,[0 0 0 0; 0 2 4 0; 0 3 0 0; 1 0 0 0]);
verifyEqual(test_case,g.Nodes.x,[1 2 2 3]');
verifyEqual(test_case,g.Nodes.y,[4 2 3 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[4 6 7 10]');
verifyEqual(test_case,g.Edges.EndNodes,[2 3; 2 4]);
verifyEqual(test_case,g.Edges.Weight,[1 1]');
end

function defaultConnectivity_test(test_case)
bw = [0 0 0 0; 0 1 1 0; 0 1 0 0; 1 0 0 0];
[g1,nodenums1] = binaryImageGraph(bw,8);
[g2,nodenums2] = binaryImageGraph(bw);
verifyEqual(test_case,g1,g2);
verifyEqual(test_case,nodenums1,nodenums2);
end

function customConnectivity_test(test_case)
% Test cases hand-checked.
bw = [0 0 0 0; 0 1 1 0; 0 1 0 0; 1 0 0 0];
[g,nodenums] = binaryImageGraph(bw,[0 0 1; 0 1 0; 1 0 0]);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,nodenums,[0 0 0 0; 0 2 4 0; 0 3 0 0; 1 0 0 0]);
verifyEqual(test_case,g.Nodes.x,[1 2 2 3]');
verifyEqual(test_case,g.Nodes.y,[4 2 3 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[4 6 7 10]');
verifyEqual(test_case,g.Edges.EndNodes,[1 3; 3 4]);
verifyEqual(test_case,g.Edges.Weight,[sqrt(2) sqrt(2)]');
end

function bigConnectivity_test(test_case)
% Test cases hand-checked.
bw = [0 0 0 0; 0 1 1 0; 0 1 0 0; 1 0 0 0];
[g,nodenums] = binaryImageGraph(bw,rot90(eye(5)));
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,nodenums,[0 0 0 0; 0 2 4 0; 0 3 0 0; 1 0 0 0]);
verifyEqual(test_case,g.Nodes.x,[1 2 2 3]');
verifyEqual(test_case,g.Nodes.y,[4 2 3 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[4 6 7 10]');
verifyEqual(test_case,g.Edges.EndNodes,[1 3; 1 4; 3 4]);
verifyEqual(test_case,g.Edges.Weight,[sqrt(2) 2*sqrt(2) sqrt(2)]');
end

function noForegroundPixels_test(test_case)
bw = zeros(4,4);
[g,nodenums] = binaryImageGraph(bw);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,height(g.Nodes),0);
verifyEqual(test_case,height(g.Edges),0);
verifyEqual(test_case,nodenums,zeros(size(bw)));
end