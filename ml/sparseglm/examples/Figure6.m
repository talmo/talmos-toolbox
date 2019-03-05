%% Analyze Blob experiment experiment (Figure 6)

%One blob case
data = mergeDataSets({'datafiles/BD-1-04.07.09-13.01.55-1000.mat',...
                      'datafiles/BD-1-04.07.09-22.09.04-1800.mat'});
numtrials = length(data.seed);
xp = data.xp;

allrg = Shuffle(301:2800);

fitrg = sort(allrg(1:2000));
verrg = sort(allrg(2001:end));

%%
%{
%Four blob case

          'BD-4-15.07.09-15.51.17-1000.mat',...
          'BD-4-15.07.09-16.16.39-1000.mat',...
          'BD-4-15.07.09-16.39.16-600.mat'});
data = mergeDataSets({'datafiles/BD-4-05.07.09-19.22.12-1000.mat',...
                      'datafiles/BD-4-05.07.09-19.57.37-1600.mat'});

allrg = Shuffle(301:2800);

fitrg = sort(allrg(1:2000));
verrg = sort(allrg(2001:end));
%}

%{
 Other data files are in:
          'BD-4-15.07.09-15.51.17-1000.mat',
          'BD-4-15.07.09-16.16.39-1000.mat',
          'BD-4-15.07.09-16.39.16-600.mat'
 For Figure 7
%}


%%
%%Recreate blob
blobim = zeros(xp.noisel,xp.noisew);
for ii = 1:xp.numblobs
    for jj = 1:xp.numblobs
        %Create meshgrid
        [xi yi] = meshgrid(-(xp.noisel-1)/2:(xp.noisel-1)/2,...
                           -(xp.noisew-1)/2:(xp.noisew-1)/2);
        cenx = xp.blobdist*(ii-xp.numblobs/2-1/2);
        ceny = xp.blobdist*(jj-xp.numblobs/2-1/2);

        blobim = blobim + exp(-((xi-cenx).^2+(yi-ceny).^2)/2/xp.sigma^2);
    end
end

%Regenerate noise fields based on seeds
noisefields = zeros(length(data.seed),16,16);
for ii = 1:length(data.seed)
    %Regenerate noise field
    [hastarget noisefield] = getnhrandvars(data.seed(ii), data.xp);
    noisefields(ii,:,:)= noisefield;
end

%%
%Reuse the folds across models so that D^CV_1 - D^CV_2 has less variance
folds = getcvfolds(length(fitrg),5);
tgain = (data.hastarget==1).*data.alpha;

%% Weight-decay prior
X = reshape(noisefields,numtrials,xp.noisew*xp.noisel);
y = data.response;
U = [tgain,ones(numtrials,1)];
qf = qfweightdecay(256);

thefitwd = cvglmfitquadprior(y(fitrg),X(fitrg,:),U(fitrg,:),qf,folds,'lambdas',exp(0:5));
imest1wd = reshape(thefitwd.w,16,16);
predswd = logit(X*thefitwd.w+U*thefitwd.u);

%% Weight-decay prior, split design matrix
X = reshape(noisefields,numtrials,xp.noisew*xp.noisel);
Xs = [((data.hastarget==1)*ones(1,size(X,2))).*X,...
           ((data.hastarget==-1)*ones(1,size(X,2))).*X];
y = data.response;
U = [tgain,data.hastarget==1,data.hastarget==-1];
A = qfweightdecay(256);
%That the regularization should be about twice as large for the no-signal cases
%was determined by cross-validation over the two hyperparameters
qf = blkdiag(A,2*A);

thefitwd2 = cvglmfitquadprior(y(fitrg),Xs(fitrg,:),U(fitrg,:),qf,folds,'lambdas',exp(0:5));
imest1wd2p1 = reshape(thefitwd2.w(1:256),16,16);
imest1wd2p2 = reshape(thefitwd2.w(257:512),16,16);
predswd2 = logit(Xs*thefitwd2.w+U*thefitwd2.u);

%% Smoothness prior
X = reshape(noisefields,numtrials,xp.noisew*xp.noisel);
y = data.response;
U = [tgain,ones(numtrials,1)];
qf = qfsmooth(16,16);

thefitsm = cvglmfitquadprior(y(fitrg),X(fitrg,:),U(fitrg,:),qf,folds,'lambdas',exp(0:5));
imest1smooth = reshape(thefitsm.w,16,16);
predsm = logit(X*thefitsm.w+U*thefitsm.u);

%% Smoothness prior, split design
X = reshape(noisefields,numtrials,xp.noisew*xp.noisel);
Xs = [((data.hastarget==1)*ones(1,size(X,2))).*X,...
           ((data.hastarget==-1)*ones(1,size(X,2))).*X];
y = data.response;
U = [tgain,tgain,data.hastarget==1,data.hastarget==-1];
A = qfsmooth(16,16);
qf = blkdiag(A,3*A);

thefitsm2 = cvglmfitquadprior(y(fitrg),Xs(fitrg,:),U(fitrg,:),qf,folds,'lambdas',exp(0:5));
imest1smooth2p1 = reshape(thefitsm2.w(1:256),16,16);
imest1smooth2p2 = reshape(thefitsm2.w(257:512),16,16);
predsm2 = logit(Xs*thefitsm2.w+U*thefitsm2.u);
    
%% Ideal observer
X = reshape(noisefields,numtrials,xp.noisew*xp.noisel);
Xs = [X*blobim(:),tgain];
y = data.response;
U = [ones(numtrials,1)];
qf = qfweightdecay(2);

thefitideal = cvglmfitquadprior(y(fitrg),Xs(fitrg,:),U(fitrg,:),qf,folds);

predsideal = logit(Xs*thefitideal.w+U*thefitideal.u);

%% Pseudo-Ideal observer
X = reshape(noisefields,numtrials,xp.noisew*xp.noisel);
Xs = [X*blobim(:)];
Xs = [Xs.*(data.hastarget==1),Xs.*(data.hastarget==-1)];
y = data.response;
U = [tgain,data.hastarget==1,data.hastarget==-1];
qf = qfweightdecay(2);

thefitideal2 = cvglmfitquadprior(y(fitrg),Xs(fitrg,:),U(fitrg,:),qf,folds);

predsideal2 = logit(Xs*thefitideal2.w+U*thefitideal2.u);

%% Sparse prior in LP basis
B = get2DLaplacianPyramidBasis(16,16,4,0.5,1.8);
XB = X*B;
%D = diag(1./std(B,[],1));
Xtilde = XB;
U = [tgain,ones(numtrials,1)];

thefitlp = cvglmfitsparseprior(y(fitrg),Xtilde(fitrg,:),U(fitrg,:),folds);
imest1lp = reshape(B*thefitlp.w,16,16);

predslp = logit(Xtilde*thefitlp.w+U*thefitlp.u);

%% Do logistic regression in Laplacian pyramid basis with split design
B = get2DLaplacianPyramidBasis(16,16,4,0.5,1.8);
XB = X*B;
Xtilde = XB;
Xtilde2 = [((data.hastarget==1)*ones(1,size(Xtilde,2))).*Xtilde,...
           ((data.hastarget==-1)*ones(1,size(Xtilde,2))).*Xtilde];
U = [tgain,data.hastarget==1,data.hastarget==-1];
thefitlp2 = cvglmfitsparseprior(y(fitrg,:),Xtilde2(fitrg,:),U(fitrg,:),folds);
imest1lpp1 = reshape(B*thefitlp2.w(1:end/2),16,16);
imest1lpp2 = reshape(B*thefitlp2.w((end/2+1):end),16,16);

predslp2 = logit(Xtilde2*thefitlp2.w+U*thefitlp2.u);

%%
%And plot the results
figure(1);
subplot(2,7,1);imagesc(blobim, [-.75,.75]);title('Signal');
subplot(2,7,2);imagesc(imest1smooth, [-.75,.75]);title('Smoothness prior');
subplot(2,7,3);imagesc(imest1smooth2p1, [-.75,.75]*1.1);title('Smoothness prior, signal on');
subplot(2,7,4);imagesc(imest1smooth2p2, [-.75,.75]*1.1);title('Smoothness prior, signal off');
subplot(2,7,5);imagesc(imest1lp, [-.75,.75]*1.0);title('LP prior');
subplot(2,7,6);imagesc(imest1lpp1, [-.75,.75]*1.0);title('LP prior, signal on');
subplot(2,7,7);imagesc(imest1lpp2, [-.75,.75]*1.0);title('LP prior, signal off');

%%
%Create the matrix of conclusions (Tables 2 and 3)

S = zeros(8,5);
%Verify predictions
allpreds = [predsideal,predswd,predsm,predslp,predsideal2,predswd2,predsm2,predslp2];
yv = (y(verrg)+1)/2;
yv = yv*ones(1,size(allpreds,2));
Dvals = -2*sum(log(yv.*allpreds(verrg,:) + (1-yv).*(1-allpreds(verrg,:))));
S(:,5) = Dvals(:);

Dcv = [thefitideal.cvdeviance,thefitwd.cvdeviance,thefitsm.cvdeviance,thefitlp.cvdeviance,thefitideal2.cvdeviance,thefitwd2.cvdeviance,thefitsm2.cvdeviance,thefitlp2.cvdeviance];
S(:,4) = Dcv(:);

Daic = [thefitideal.aic,thefitwd.aic,thefitsm.aic,thefitlp.aic,...
        thefitideal2.aic,thefitwd2.aic,thefitsm2.aic,thefitlp2.aic];
S(:,3) = Daic(:);

D = [thefitideal.deviance,thefitwd.deviance,thefitsm.deviance,thefitlp2.deviance,...
     thefitideal2.deviance,thefitwd2.deviance,thefitsm2.deviance,thefitlp.deviance];

S(:,1) = D(:);

df = [ thefitideal.df,thefitwd.df, thefitsm.df, thefitlp.df,...
      thefitideal2.df,thefitwd2.df,thefitsm2.df,thefitlp2.df];
 
S(:,2) = df(:);
 
fprintf('\n\n')
fprintf('%4.0f %5.1f %4.0f %4.0f %5.1f\n',S')
fprintf('\n\n')
