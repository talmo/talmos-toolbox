function [obj] = fitMixGauss(xyData,nrgaussians,param,plotresult,replicates,iterations,nlTol)
% this function requires Statistics toolbox

% xyData: either xy data as computed from an image using function imageToData, or directly an image (8bit grayscale as matlab
% matrix); if we pass an image matrix directly, we have to pass 'image' as
% param (see below); we then automatically call imageToData(xyData) to convert image to xyData

% param: either [] or 'image' (default = [])

% nrgaussians: how many gaussians to fit

% replicates: how many times matlab shall run the fitting algorithm => from all
% replicates' results, matlab chooses the 'best' one (a number between 1 and 10 is meaningful);
% IMPORTANT: instead of passing 'replicates' as integer, a start structure can be passed (see
% parameter 'Start' in gmdistribution.fit - there will be only a single run
% of the fitting algorithm if we pass startvalues):
% as startstructure we pass a structure containing two arrays, mu (containing the estimated x y coordinates of the centroid for each distribution)
% and Sigma (containing the estimated 2X2 covariance matrix for each
% distribution)

% iterations: how many computation-iterations within one run of the fitting
% algorithm (a number between 50 and 300 is meaningful)

% nlTol: error tolerance for matlab to declare convergence as successful
% (obj.Converged = true); the higher, the more conservative (a value
% between 6 and 12 is meaningful)

    
if nargin<7 || isempty(nlTol)
    tolfun = 1e-6;
else
    tolfun = 10^-nlTol;
end

if nargin<6 || isempty(iterations)
    iterations = 100;
end

startStruct = false;
if nargin<5 || isempty(replicates)
    replicates = 1;
elseif isstruct(replicates)
    startStruct = true;
end

if nargin<4 || isempty(plotresult)
    plotresult = false;
end

if nargin<3 || isempty(param)
    param = [];
end
if ~isempty(param) && ~strcmp(param,'image')
    error('wrong parameter')
end

if strcmp(param,'image')
    curxyData = imageToData(xyData);
else
    curxyData = xyData;
end


options = statset('TolFun',tolfun,'MaxIter',iterations,'Display','off');
% i dont know what 'Display' off is really good for...

if startStruct
    obj = gmdistribution.fit(curxyData,nrgaussians,'Start',replicates,'Options',options);
else
    obj = gmdistribution.fit(curxyData,nrgaussians,'Replicates',replicates,'Options',options);
end

if ~plotresult
    return
end


means = obj.mu;

% display data
xmin = min(curxyData(:,1));
xmax = max(curxyData(:,1));
ymin = min(curxyData(:,2));
ymax = max(curxyData(:,2));
xdist = xmax - xmin;
ydist = ymax - ymin;
if strcmp(param,'image')
    subplot(2,1,1);
    imagesc(xyData); axis image; colormap gray;
    set(gca, 'XLim', [round(xmin-xdist/3) round(xmax+xdist/3)], 'YLim', [round(ymin-ydist/3) round(ymax+ydist/3)], 'YDir', 'reverse');
    subplot(2,1,2);
end
scatter(curxyData(:,1),curxyData(:,2),10,'.');
hold on;
set(gca, 'XLim', [round(xmin-xdist/3) round(xmax+xdist/2)], 'YLim', [round(ymin-ydist/3) round(ymax+ydist/2)], 'YDir', 'reverse');
h = ezcontour(@(x,y)pdf(obj,[x y]),[round(xmin-xdist/3) round(xmax+xdist/3)], [round(ymin-ydist/3) round(ymax+ydist/3)]);
plot(means(:,1),means(:,2),'ro');
hold off;

end