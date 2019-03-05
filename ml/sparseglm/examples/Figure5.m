%% Perform logistic regression using l1 prior in different bases

%Attempt to reverse correlate linear observers
%First with inhibitory surround
numtrials = 2000;

%Signal
[xi yi] = meshgrid(-8:8,-8:8);
signal = exp(-(xi.^2+yi.^2)/2/1.5^2); %Gaussian blob, sigma = 1.5

%Template
template = exp(-(xi.^2+yi.^2)/2/1.75^2) - 0.5*exp(-(xi.^2+yi.^2)/2/5^2); %DOG, sigma = 1.75, 5

[noisefields nplus signals responses] = simulateLinearObserver(numtrials,signal(:),template(:));

X = noisefields;
U = [signals ones(numtrials,1)];
y = responses;

%%
%Dirac basis
thefit = cvglmfitsparseprior(y,X,U,getcvfolds(length(y),5));
imestdirac = reshape(thefit.w,17,17);

%%
%Laplacian pyramid basis
B = get2DLaplacianPyramidBasis(17,17,4,1,1.2);
XB = X*B;
Xtilde = XB;

thefit = cvglmfitsparseprior(y,Xtilde,U,getcvfolds(length(y),5));
imestlp = reshape(B*thefit.w,17,17);

%%
%Steerable pyramid basis (requires the steerable pyramid toolbox)
%(http://www.cns.nyu.edu/~eero/steerpyr/)
B = getBasisMatrix('sp1Filters',17,17);
XB = X*B;
D = diag(1./std(XB,[],1));
Xtilde = XB*D;

thefit = cvglmfitsparseprior(y,Xtilde,U,getcvfolds(length(y),5));
imestsp = reshape(B*D*thefit.w,17,17);

%%
%Now without inhibitory surround
numtrials = 2000;

%Signal
[xi yi] = meshgrid(-8:8,-8:8);
signal = exp(-(xi.^2+yi.^2)/2/1.5^2); %Gaussian blob, sigma = 1.5

%Template
template2 = exp(-(xi.^2+yi.^2)/2/1.75^2) - 0*0.5*exp(-(xi.^2+yi.^2)/2/5^2); %DOG, sigma = 1.75, 5

[noisefields nplus signals responses] = simulateLinearObserver(numtrials,signal(:),template2(:));

X = noisefields;
U = [signals ones(numtrials,1)];
y = responses;

%%
%Dirac basis
thefit = cvglmfitsparseprior(y,X,U,getcvfolds(length(y),5));
imestdirac2 = reshape(thefit.w,17,17);

%%
%Laplacian pyramid basis
B = get2DLaplacianPyramidBasis(17,17,4,0.5,1.2);
XB = X*B;
Xtilde = XB;

thefit = cvglmfitsparseprior(y,Xtilde,U,getcvfolds(length(y),5));
imestlp2 = reshape(B*thefit.w,17,17);

%%
%Steerable pyramid basis (requires the steerable pyramid toolbox)
%(http://www.cns.nyu.edu/~eero/steerpyr/)
B = getBasisMatrix('sp1Filters',17,17);
XB = X*B;
D = diag(1./std(XB,[],1));
Xtilde = XB*D;

thefit = cvglmfitsparseprior(y,Xtilde,U,getcvfolds(length(y),5));
imestsp2 = reshape(B*D*thefit.w,17,17);

%% Show sample basis functions
sdirac = zeros(17,17);
sdirac(3,11) = 1;
sdirac(7,8) = -1;
sdirac(5,2) = 1;
sdirac = reshape(sdirac(:)*ones(1,3),17,17,3);
sdirac = (sdirac + 1)/2;

%Now for Laplacian pyramid
B = get2DLaplacianPyramidBasis(17,17,4,1,1.2);
slpyr = reshape(B(:,20) + B(:,255) - 1.5*B(:,340) - 4*B(:,373),17,17);
slpyr = reshape(slpyr(:)*ones(1,3),17,17,3);
slpyr = (slpyr + 1)/2;

[s,c] = buildSpyr(zeros(17,17),'auto','sp1Filters');
s(919) = 2.05;
s(330) = 2;
s(770) = -2;
sspyr = reconSpyr(s*1.8,c,'sp1Filters');
sspyr = reshape(sspyr(:)*ones(1,3),17,17,3);
sspyr = (sspyr + 1)/2;

%%

subplot(3,4,1);imagesc(template  ,[-1 1]*.5);axis off;
subplot(3,4,2);imagesc(imestdirac,[-1 1]*.3);axis off;
subplot(3,4,3);imagesc(imestlp   ,[-1 1]*.3);axis off;
subplot(3,4,4);imagesc(imestsp   ,[-1 1]*.3);axis off;

subplot(3,4,5);imagesc(template2   ,[-1 1]*.75);axis off;
subplot(3,4,6);imagesc(imestdirac2 ,[-1 1]*.75);axis off;
subplot(3,4,7);imagesc(imestlp2    ,[-1 1]*.75);axis off;
subplot(3,4,8);imagesc(imestsp2    ,[-1 1]*.75);axis off;

subplot(3,4,10);image(sdirac);axis off;
subplot(3,4,11);image(slpyr);axis off;
subplot(3,4,12);image(sspyr);axis off;
%colormap(gray);

