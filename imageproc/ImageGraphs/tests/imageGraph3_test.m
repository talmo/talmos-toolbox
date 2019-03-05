function tests = imageGraph3_test

% Copyright 2015 The MathWorks, Inc.
% Steve Eddins

tests = functiontests(localfunctions);
end

function connectivity26_test(test_case)
% Test cases hand-checked.
g = imageGraph3([2 3 2],26);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3 1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2 1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 1 1 1 2 2 2 2 2 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,(1:12)');

expected_end_nodes = [ ...
   1     2
   1     3
   1     4
   1     7
   1     8
   1     9
   1    10
   2     3
   2     4
   2     7
   2     8
   2     9
   2    10
   3     4
   3     5
   3     6
   3     7
   3     8
   3     9
   3    10
   3    11
   3    12
   4     5
   4     6
   4     7
   4     8
   4     9
   4    10
   4    11
   4    12
   5     6
   5     9
   5    10
   5    11
   5    12
   6     9
   6    10
   6    11
   6    12
   7     8
   7     9
   7    10
   8     9
   8    10
   9    10
   9    11
   9    12
   10    11
   10    12
   11    12  ];

expected_edge_weights = [ ...
   1
   1
   sqrt(2)
   1
   sqrt(2)
   sqrt(2)
   sqrt(3)
   sqrt(2)
   1
   sqrt(2)
   1
   sqrt(3)
   sqrt(2)
   1
   1
   sqrt(2)
   sqrt(2)
   sqrt(3)
   1
   sqrt(2)
   sqrt(2)
   sqrt(3)
   sqrt(2)
   1
   sqrt(3)
   sqrt(2)
   sqrt(2)
   1
   sqrt(3)
   sqrt(2)
   1
   sqrt(2)
   sqrt(3)
   1
   sqrt(2)
   sqrt(3)
   sqrt(2)
   sqrt(2)
   1
   1
   1
   sqrt(2)
   sqrt(2)
   1
   1
   1
   sqrt(2)
   sqrt(2)
   1
   1  ];

verifyEqual(test_case,g.Edges.EndNodes,expected_end_nodes);
verifyEqual(test_case,g.Edges.Weight,expected_edge_weights);
end

function connectivity18_test(test_case)
% Test cases hand-checked.
g = imageGraph3([2 3 2],18);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3 1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2 1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 1 1 1 2 2 2 2 2 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,(1:12)');

expected_end_nodes = [ ...
   1     2
   1     3
   1     4
   1     7
   1     8
   1     9
   2     3
   2     4
   2     7
   2     8
   2    10
   3     4
   3     5
   3     6
   3     7
   3     9
   3    10
   3    11
   4     5
   4     6
   4     8
   4     9
   4    10
   4    12
   5     6
   5     9
   5    11
   5    12
   6    10
   6    11
   6    12
   7     8
   7     9
   7    10
   8     9
   8    10
   9    10
   9    11
   9    12
   10    11
   10    12
   11    12  ];

expected_edge_weights = [ ...
   1
   1
   sqrt(2)
   1
   sqrt(2)
   sqrt(2)
   sqrt(2)
   1
   sqrt(2)
   1
   sqrt(2)
   1
   1
   sqrt(2)
   sqrt(2)
   1
   sqrt(2)
   sqrt(2)
   sqrt(2)
   1
   sqrt(2)
   sqrt(2)
   1
   sqrt(2)
   1
   sqrt(2)
   1
   sqrt(2)
   sqrt(2)
   sqrt(2)
   1
   1
   1
   sqrt(2)
   sqrt(2)
   1
   1
   1
   sqrt(2)
   sqrt(2)
   1
   1  ];

verifyEqual(test_case,g.Edges.EndNodes,expected_end_nodes);
verifyEqual(test_case,g.Edges.Weight,expected_edge_weights);
end

function connectivity6_test(test_case)
% Test cases hand-checked.
g = imageGraph3([2 3 2],6);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3 1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2 1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 1 1 1 2 2 2 2 2 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,(1:12)');

expected_end_nodes = [ ...
   1     2
   1     3
   1     7
   2     4
   2     8
   3     4
   3     5
   3     9
   4     6
   4    10
   5     6
   5    11
   6    12
   7     8
   7     9
   8    10
   9    10
   9    11
   10    12
   11    12  ];
 
expected_edge_weights = ones(20,1);

verifyEqual(test_case,g.Edges.EndNodes,expected_end_nodes);
verifyEqual(test_case,g.Edges.Weight,expected_edge_weights);
end

function defaultConnectivity_test(test_case)
g1 = imageGraph3([2 3 2],26);
g2 = imageGraph3([2 3 2]);
verifyEqual(test_case,g1,g2);
end
 
function customConnectivity_test(test_case)
% Test cases hand-checked.
g = imageGraph3([2 3 2],reshape([1 1 1],1,1,3));
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3 1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2 1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 1 1 1 2 2 2 2 2 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,(1:12)');

expected_end_nodes = [ ...
     1     7
     2     8
     3     9
     4    10
     5    11
     6    12  ];
  
expected_edge_weights = ones(6,1);

verifyEqual(test_case,g.Edges.EndNodes,expected_end_nodes);
verifyEqual(test_case,g.Edges.Weight,expected_edge_weights);
end

function bigConnectivity_test(test_case)
% Test cases hand-checked.
g = imageGraph3([2 3 2],[1 1 1 1 1]);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,g.Nodes.x,[1 1 2 2 3 3 1 1 2 2 3 3]');
verifyEqual(test_case,g.Nodes.y,[1 2 1 2 1 2 1 2 1 2 1 2]');
verifyEqual(test_case,g.Nodes.z,[1 1 1 1 1 1 2 2 2 2 2 2]');
verifyEqual(test_case,g.Nodes.PixelIndex,(1:12)');

expected_end_nodes = [ ...
   1     3
   1     5
   2     4
   2     6
   3     5
   4     6
   7     9
   7    11
   8    10
   8    12
   9    11
   10    12  ];

expected_edge_weights = [ ...
   1
   2
   1
   2
   1
   1
   1
   2
   1
   2
   1
   1  ];
  
verifyEqual(test_case,g.Edges.EndNodes,expected_end_nodes);
verifyEqual(test_case,g.Edges.Weight,expected_edge_weights);
end

function emptyImage_test(test_case)
g = imageGraph3([2 0 3]);
verifyInstanceOf(test_case,g,'graph');
verifyEqual(test_case,height(g.Nodes),0);
verifyEqual(test_case,height(g.Edges),0);
end