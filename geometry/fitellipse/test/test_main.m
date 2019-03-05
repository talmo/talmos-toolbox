%% Test FITELLIPSE - run through all possibilities
% Example
%% 1) Linear fit, bookstein constraint
% Data points
x = [1 2 5 7 9 6 3 8;
     7 6 8 7 5 7 2 4];

[z, a, b, alpha] = fitellipse(x, 'linear');

%% 2) Linear fit, Trace constraint
% Data points
x = [1 2 5 7 9 6 3 8;
     7 6 8 7 5 7 2 4];

[z, a, b, alpha] = fitellipse(x, 'linear', 'constraint', 'trace');

%% 3) Nonlinear fit
% Data points
x = [1 2 5 7 9 6 3 8;
     7 6 8 7 5 7 2 4];

[z, a, b, alpha] = fitellipse(x);

% Changing the tolerance, maxits
[z, a, b, alpha] = fitellipse(x, 'tol', 1e-8, 'maxits', 100);

%% Plotting
hF = figure();
hAx = axes('Parent', hF);
h = plotellipse(hAx, z, a, b, alpha, 'r.');

hold on
plotellipse(z, a, b, alpha)
