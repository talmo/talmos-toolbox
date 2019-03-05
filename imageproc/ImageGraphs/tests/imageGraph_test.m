function tests = imageGraph_test

% Copyright 2015 The MathWorks, Inc.
% Steve Eddins

tests = functiontests(localfunctions);
end

function connectivity8_test(test_case)
% Test cases hand-checked.
g = imageGraph([2 3],8);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[1 2 3 4 5 6]');
verifyEqual(test_case,g.Edges.EndNodes,[1 2; 1 3; 1 4; 2 3; 2 4; 3 4; 3 5; 3 6; 4 5; 4 6; 5 6]);
verifyEqual(test_case,g.Edges.Weight,[1 1 sqrt(2) sqrt(2) 1 1 1 sqrt(2) sqrt(2) 1 1]');
end

function defaultConnectivity_test(test_case)
g1 = imageGraph([2 3],8);
g2 = imageGraph([2 3]);
verifyEqual(test_case,g1,g2);
end

function connectivity4_test(test_case)
% Test cases hand-checked.
g = imageGraph([2 3],4);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[1 2 3 4 5 6]');
verifyEqual(test_case,g.Edges.EndNodes,[1 2; 1 3; 2 4; 3 4; 3 5; 4 6; 5 6]);
verifyEqual(test_case,g.Edges.Weight,[1 1 1 1 1 1 1]');
end

function customConnectivity_test(test_case)
% Test cases hand-checked.
g = imageGraph([2 3],[1 1 1]);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[1 2 3 4 5 6]');
verifyEqual(test_case,g.Edges.EndNodes,[1 3; 2 4; 3 5; 4 6]);
verifyEqual(test_case,g.Edges.Weight,[1 1 1 1]');
end

function bigConnectivity_test(test_case)
% Test cases hand-checked.
g = imageGraph([2 3],[1 1 1 1 1]);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[1 2 3 4 5 6]');
verifyEqual(test_case,g.Edges.EndNodes,[1 3; 1 5; 2 4; 2 6; 3 5; 4 6]);
verifyEqual(test_case,g.Edges.Weight,[1 2 1 2 1 1]');
end

function emptyImage_test(test_case)
g = imageGraph([0 1]);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,height(g.Nodes),0);
verifyEqual(test_case,height(g.Edges),0);
end