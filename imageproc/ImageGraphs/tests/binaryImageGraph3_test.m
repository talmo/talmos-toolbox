function tests = binaryImageGraph3_test

% Copyright 2015 The MathWorks, Inc.
% Steve Eddins

tests = functiontests(localfunctions);
end

function connectivity26_test(test_case)
% Test cases hand-checked.
bw = cat(3,[0 1; 1 1],[0 1; 0 0]);
[g,nodenums] = binaryImageGraph3(bw,26);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 2 2 2]');
verifyEqual(test_case,g.Nodes.y,[2 1 2 1]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[2 3 4 7]');
verifyEqual(test_case,nodenums,cat(3,[0 2; 1 3],[0 4; 0 0]));
verifyEqual(test_case,g.Edges.EndNodes,[1 2; 1 3; 1 4; 2 3; 2 4; 3 4]);
verifyEqual(test_case,g.Edges.Weight,[sqrt(2) 1 sqrt(3) 1 1 sqrt(2)]');
end

function connectivity18_test(test_case)
% Test cases hand-checked.
bw = cat(3,[0 1; 1 1],[0 1; 0 0]);
[g,nodenums] = binaryImageGraph3(bw,18);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 2 2 2]');
verifyEqual(test_case,g.Nodes.y,[2 1 2 1]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[2 3 4 7]');
verifyEqual(test_case,nodenums,cat(3,[0 2; 1 3],[0 4; 0 0]));
verifyEqual(test_case,g.Edges.EndNodes,[1 2; 1 3; 2 3; 2 4; 3 4]);
verifyEqual(test_case,g.Edges.Weight,[sqrt(2) 1 1 1 sqrt(2)]');
end

function connectivity6_test(test_case)
% Test cases hand-checked.
bw = cat(3,[0 1; 1 1],[0 1; 0 0]);
[g,nodenums] = binaryImageGraph3(bw,6);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 2 2 2]');
verifyEqual(test_case,g.Nodes.y,[2 1 2 1]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[2 3 4 7]');
verifyEqual(test_case,nodenums,cat(3,[0 2; 1 3],[0 4; 0 0]));
verifyEqual(test_case,g.Edges.EndNodes,[1 3; 2 3; 2 4]);
verifyEqual(test_case,g.Edges.Weight,[1 1 1]');
end

function customConnectivity_test(test_case)
% Test cases hand-checked.
bw = cat(3,[0 1; 1 1],[0 1; 0 0]);
[g,nodenums] = binaryImageGraph3(bw,rot90(eye(3)));
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 2 2 2]');
verifyEqual(test_case,g.Nodes.y,[2 1 2 1]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,[2 3 4 7]');
verifyEqual(test_case,nodenums,cat(3,[0 2; 1 3],[0 4; 0 0]));
verifyEqual(test_case,g.Edges.EndNodes,[1 2]);
verifyEqual(test_case,g.Edges.Weight,sqrt(2));
end

function defaultConnectivity_test(test_case)
bw = cat(3,[0 1; 1 1],[0 1; 0 0]);
[g1,nodenums1] = binaryImageGraph3(bw,26);
[g2,nodenums2] = binaryImageGraph3(bw);
verifyEqual(test_case,g1,g2);
verifyEqual(test_case,nodenums1,nodenums2);
end

function noForegroundPixels_test(test_case)
bw = zeros(2,2,2);
[g,nodenums] = binaryImageGraph3(bw);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,height(g.Nodes),0);
verifyEqual(test_case,height(g.Edges),0);
verifyEqual(test_case,nodenums,zeros(size(bw)));
end
