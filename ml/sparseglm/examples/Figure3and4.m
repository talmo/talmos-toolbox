%Attempt to reverse correlate linear observers
numtrials = 10000;

%Signal
xi = -31.5:31.5;
signal = cos(5*xi/(2*pi)).*exp(-(xi.^2)/7^2); %Gaussian blob, sigma = 1.5

%Template
template = signal; %DOG, sigma = 1.75, 5

%Note: you might have to restart this a couple of times. Sometimes the
%generated responses (especially for low number of trials) are so noisy 
%that no amount of processing will recover the template
[noisefields nplus signals responses actualresps] = simulateLinearObserver(numtrials,signal(:),template(:));

%%
%Get Laplacian pyramid with half-levels and set up such that the smoothness
%of the finest element is slightly less than that of the signal
myPyr = get1DLaplacianPyramidBasis(64,4,.5,2.5);

%Plot the signal and compare with elements of the Laplacian pyramid we
%chose
subplot(5,1,1);plot(signal*1);axis([0 64 -2 2]);
subplot(5,1,2);plot(2*myPyr(:,32));axis([0 64 -2 2]);
subplot(5,1,3);plot(2*myPyr(:,88));axis([0 64 -2 2]);
subplot(5,1,4);plot(2*myPyr(:,128));axis([0 64 -2 2]);
subplot(5,1,5);plot(2*myPyr(:,166));axis([0 64 -2 2]);

%%
%Look at kernels derived from the classification image formula
figure;
numtrialss = [200,500,1000,5000,10000];

for jj = 1:length(numtrialss)
    rg = 1:numtrialss(jj);
    
    retrievedkern = zeros(64,1);
    subkerns = zeros(4,64);

    bins = (signals+1)/2 + (responses + 1) + 1;
    bins = [bins(rg);zeros(10000-length(rg),1)];
    
    for ii = 1:4
        subkerns(ii,:) = mean(noisefields(bins == ii,:));
    end

    retrievedkern = squeeze(-subkerns(1,:) -subkerns(2,:) +subkerns(3,:) +subkerns(4,:));
    
    
    subplot(3,5,jj);plot(retrievedkern/norm(retrievedkern)*2);axis([0 64 -2 2]);
    title(sprintf('%d trials, r = %.2f',numtrialss(jj),corr(retrievedkern(:),template(:))));
end

%% Look at estimated templates for 200 - 1k trials
%  First with the smoothness prior

%  Look at kernels from smoothness prior
numtrialss = [200,500,1000,5000,10000];

%Quadratic form associated with smoothness prior
qf = qfsmooth1D(64);

for jj = 1:3
    rg = 1:numtrialss(jj);
    X = noisefields(rg,:);
    U = [signals(rg),ones(length(rg),1)];
    y = responses(rg);

    qf = qfsmooth1D(64);
    
    tic;
    %Note the use of 10-fold rather than 5-fold CV for such low number of
    %trials
    thefit = cvglmfitquadprior(y,X,U,qf,getcvfolds(length(y),10));
    toc;
    
    w = thefit.w;
    
    subplot(3,5,jj+5);plot(w/norm(w)*2);axis([0 64 -2 2]);
    title(sprintf('r = %.2f',corr(w,template(:))));
end

%%
%  Look at kernels from sparseness prior in Laplacian pyramid basis
numtrialss = [200,500,1000,5000,10000];

for jj = 1:3
    rg = 1:numtrialss(jj);
    X = noisefields(rg,:)*myPyr; %X*B
    %whitener = diag(1./std(X,[],1));
    %X = X*whitener; %Whiten to standard deviation = 1 (X*B*D)
    U = [signals(rg),ones(length(rg),1)];
    y = responses(rg);

    tic;
    %Note the use of 10-fold rather than 5-fold CV for such low number of
    %trials
    thefit = cvglmfitsparseprior(y,X,U,getcvfolds(length(y),10)); 
    toc;
    
    thefig = myPyr*thefit.w*2; %(calc B*D*_w_ to get w)
    thefig = thefig/norm(thefig)*2;
    
    subplot(3,5,jj+10);plot(thefig);axis([0 64 -2 2]);
    title(sprintf('r = %.2f',corr(thefig,template(:))));
end

%Save the last fit for figure 5
fig5fit = thefit;



%% Now fill in the rest (takes a bit of time)

%  Look at kernels from smoothness prior
numtrialss = [200,500,1000,5000,10000];

%Quadratic form associated with smoothness prior
qf = qfsmooth1D(64);

for jj = 4:5
    rg = 1:numtrialss(jj);
    X = noisefields(rg,:);
    U = [signals(rg),ones(length(rg),1)];
    y = responses(1,rg)';

    tic;
    thefit = cvglmfitquadprior(y,X,U,qf,5);
    toc;
    
    w = thefit.w;
    
    subplot(3,5,jj+5);plot(w/norm(w)*2);axis([0 64 -2 2]);
    title(sprintf('r = %.2f',corr(w,template(:))));
end


%% 
%  Look at kernels from sparseness prior in Laplacian pyramid basis
numtrialss = [200,500,1000,5000,10000];

for jj = 4:5
    rg = 1:numtrialss(jj);
    X = noisefields(rg,:)*myPyr; %X*B
    whitener = diag(1./std(X,[],1));
    X = X*whitener; %Whiten to standard deviation = 1 (X*B*D)
    U = [signals(rg),ones(length(rg),1)];
    y = responses(1,rg)';

    tic;
    thefit = cvglmfitsparseprior(y,X,U,5);
    toc;
    
    thefig = myPyr*whitener*thefit.w*2; %(calc B*D*_w_ to get w)
    thefig = thefig/norm(thefig)*2;
    
    subplot(3,5,jj+10);plot(thefig);axis([0 64 -2 2]);
    title(sprintf('r = %.2f',corr(thefig,template(:))));
end

%%
%Now for figure 4
%Plot a sample path
figure;plot(-log(reverse(fig5fit.lambdas)),flipud(fig5fit.ws'));
xlabel('log 1/\lambda');
title('Regularization path');

%% 
%Now plot reconstructions at different lambdas
%The exact lambdas that nicely show the effect change from simulation
%to simulation. You might have to play around with the numbers. I've
%attempted to minimize the playing around you have to do here by showing
%lambdas as a fraction of the maximal lambda
figure;
lambdas = [88,35,14,7,1]/120;

for ii = 1:length(lambdas)
    [thelamb closestlambda] = min(abs(fig5fit.lambdas/max(fig5fit.lambdas)-lambdas(ii)));
    subplot(1,length(lambdas),ii);
    plot(myPyr*fig5fit.ws(:,closestlambda));
    title(sprintf('\\lambda = %.1f',fig5fit.lambdas(closestlambda)));
    axis([0 63 max(abs(myPyr*fig5fit.ws(:,closestlambda)))*[-1.2 1.2]])
end

