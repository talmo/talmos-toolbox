function exampleFindEllipses

testimage = load('exampleOverlapEllipses.mat');
testimage = testimage.xyData;

% we assume 2 overlapping ellipses in our testimage

%------------------------------------------------------------------------
% for the fitting we can specify start parameters to run the mixture model
% algorithm:
% if we want to pass a start structure, we have to pass estimates for
% centerpoint AND covariance matrix for every ellipse
% if we dont want to pass a strart structure, we have to pass # replicates
% (see comments in fitMixGauss.m)
% if we have a good estimate, passing a start structure greatly speeds up
% the fitting

% first we define two estimates for the gravity centers
elgrav1 = [4,5];
elgrav2 = [4,12];

% and we also have to define the covariance matrices for both ellipses
elsigma1 = [[1 -0.5];[-0.5 4]];
elsigma2 = [[1.5 -0.75];[-0.75 3.5]];


startStruct.mu = [elgrav1;elgrav2];
startStruct.Sigma(:,:,1) = elsigma1;
startStruct.Sigma(:,:,2) = elsigma2;
%------------------------------------------------------------------------



% now we do the fitting:
% sometimes gmdistribution.fit fails to converge and returns an error
% (see discussion
% http://www.mathworks.in/matlabcentral/newsreader/view_thread/168289)
% => we could try-catch this error and make another attempt with more
% iterations
try
obj = fitMixGauss(testimage,2,'image',true,startStruct,100,10);
catch
    clear obj;
    obj.Converged = false;
end
if ~obj.Converged
    obj = fitMixGauss(testimage,2,'image',true,startStruct,200,10);
end

if obj.Converged
    % now we can extract the center coordinates (gravity centers) of the
    % ellipses
    cencoor = obj.mu; % 1st column are x coordinates, 2nd column y coordinates, each row is one ellipse
    % and the covariance matrices
    sigma = obj.Sigma;
    % and the ellipses' angles in radians
    theta = atan(obj.Sigma(2,1,:)./obj.Sigma(1,1,:));
    theta = squeeze(theta);
    % and estimates for ellipses' axes' lengths (in pixels)
    for jj=1:size(obj.Sigma,3)
        ev = eig(obj.Sigma(:,:,jj));
        semax1 = sqrt(max(ev));
        semax2 = sqrt(min(ev));
        axes(jj,1) = 2 * semax1;
        axes(jj,2) = 2 * semax2;
    end
end

disp('finished')



