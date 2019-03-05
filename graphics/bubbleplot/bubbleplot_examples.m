%% Bubbleplot visualization of multi-dimensional data
% bubbleplot creates 2D and 3D scatter plots of multivariate data. Up to 7
% dimensions of data can be visualized by using marker color, shape, size
% and text annotations to convey information about the data. Continuous and
% discrete valued data are supported

%% Load Data
% Load a sample data set of automobile statistics 

load carsmall
Origin = cellstr(Origin);

%% 3D Bubble
% In this chart,
% X: Acceleration (continuous)
% Y: Horsepower (continuous)
% Z: MPG (continuous)
% Size: Weight (continuous)
% Color: Model_Year (discrete, ordinal)
% Shape: Origin

clf
bubbleplot(Acceleration, Horsepower, MPG, Weight, Model_Year, Origin);
grid on
xlabel('Acceleration');ylabel('Horsepower');zlabel('MPG');

%% Bubbleplot with clickableLegend
% clickableLegend works well with bubbleplot and enables you to hide or
% highlight groups of data

clf
h = bubbleplot(Acceleration, Horsepower, MPG, Weight, Model_Year, Origin);
grid on
xlabel('Acceleration');ylabel('Horsepower');zlabel('MPG');

clickableLegend(h, unique(Origin), 'groups', Origin, 'plotOptions', ...
    {'MarkerSize', 8, 'MarkerFaceColor', 'c'});


%% 3D Bubble Plot visualizing 7 dimensions
% In this chart,
% X: Acceleration (continuous)
% Y: Horsepower (continuous)
% Z: MPG (continuous)
% Size: Weight (continuous)
% Color: Model_Year (discrete, ordinal)
% Shape: Cylinders
% Text: Origin

clf
bubbleplot(Acceleration, Horsepower, MPG, Weight, Model_Year, Cylinders,... 
            Origin, 'fontSize',6);
grid on
xlabel('Acceleration');ylabel('Horsepower');zlabel('MPG');

%% 2D Bubble Plot visualizing 5 dimensions with text labels
% In this chart,
% X: Horsepower (continuous)
% Y: MPG (continuous)
% Size: Acceleration (continuous)
% Color: Displacement (continuous)
% Shape: Origin
% Text: Manufacturer

clf
h = bubbleplot(Horsepower, MPG, [], Acceleration, Displacement, Origin,...
    Mfg, 'fontSize', 6);
xlabel('Horsepower');ylabel('MPG');
grid on;
clickableLegend(h, unique(Origin), 'groups', Origin, 'plotOptions', ...
    {'MarkerSize', 8, 'MarkerFaceColor', 'c'});
