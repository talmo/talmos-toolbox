function tests = plotImageGraph_test

% Copyright 2015 The MathWorks, Inc.
% Steve Eddins

tests = functiontests(localfunctions);
end

function teardown(~)
close all
end

function basicPositive_test(test_case)
g = imageGraph([2 3]);
gp = plotImageGraph(g);
verifyInstanceOf(test_case,gp,'matlab.graphics.chart.primitive.GraphPlot');
end

function theeDNotSupported_test(test_case)
f = @() plotImageGraph(imageGraph3([2 3 2]));
verifyError(test_case,f,'se:ig:ThreeDPlotting');
end