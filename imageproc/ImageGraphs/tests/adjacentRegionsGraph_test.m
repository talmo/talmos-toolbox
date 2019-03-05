function tests = adjacentRegionsGraph_test

% Copyright 2015 The MathWorks, Inc.
% Steve Eddins

tests = functiontests(localfunctions);
end

function connectivity8_test(test_case)
L = repelem([5 10; 1.5 20],4,3);
g = adjacentRegionsGraph(L,8);
verifyEqual(test_case,g.Nodes.Label,[1.5 5 10 20]');
verifyEqual(test_case,g.Edges.EndNodes,[1 2; 1 3; 1 4; 2 3; 2 4; 3 4]);
verifyEqual(test_case,g.Edges.Labels,[1.5 5; 1.5 10; 1.5 20; 5 10; 5 20; 10 20]);
end

function connectivity4_test(test_case)
L = repelem([5 10; 1.5 20],4,3);
g = adjacentRegionsGraph(L,4);
verifyEqual(test_case,g.Nodes.Label,[1.5 5 10 20]');
verifyEqual(test_case,g.Edges.EndNodes,[1 2; 1 4; 2 3; 3 4]);
verifyEqual(test_case,g.Edges.Labels,[1.5 5; 1.5 20; 5 10; 10 20]);
end

function defaultConnectivity_test(test_case)
L = repelem([5 10; 1.5 20],4,3);
g1 = adjacentRegionsGraph(L,8);
g2 = adjacentRegionsGraph(L);
verifyEqual(test_case,g1,g2);
end