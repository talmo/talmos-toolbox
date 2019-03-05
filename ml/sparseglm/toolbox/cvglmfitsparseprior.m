function [fullfit] = cvglmfitsparseprior(y,X,U,folds,varargin)
    %[thefit] = cvglmfitsparseprior(y,X,U,folds,varargin)
    %
    % Optimizes a GLM model through MAP where the internal variable is generated through:
    % eta = X*w + U*u
    %
    % And E(y) = mu = g^-1(eta), where E is the expected value and g is the link
    % function and:
    %
    % p(y|mu) = some exponential family distribution
    %
    % Where there exists a sparse (Laplacian) prior on w of the form:
    %
    % p(w) = exp(-lambda*||w||_1),    p(u) = uniform everywhere (no prior)
    %
    % The algorithm performs cross-validation in batches, first fitting all
    % folds from 0.7*lambda_max to lambda_max. If the cv deviance rises
    % dramatically for decreasing lambda, this indicates that we are beyond
    % the range of lambda for which the best lambda is likely to be in. In
    % that case the algorithm exits to fit the full model. Otherwise, all
    % folds are fit again for 0.7*0.7lambda_max to 0.7*lambda_max and so
    % forth. The function returns the best w, the best lambda, cross-validated 
    % deviances, and everything else required to debug the model. In pseudo-code:
    % ---
    % factor = 1;
    % while 1
    %      factor = factor*sqrt(1/2)
    %      for ii = 1:num folds
    %         fit data in the i'th fold from lambda = lambda_max*factor..lambda
    %         compute cv deviance for that fold
    %      end
    %      interpolate cv deviances over all lambdas/lambdas_max
    %      if min(cv deviances) < (cv deviance at lambda_max*factor) -
    %           cvdeviancedelta || factor <= minlambda
    %           bestlambda = argmin over lambda of cv deviances
    %           break;
    %      end
    % end
    % fit everything from lambda = lambda_max*factor..lambda
    % set woptimal = w in the last fit for which lambda is closest to
    % bestlambda
    % ---
    % 
    % Required parameters
    % --------------------------------------------------------------------
    % X,U,y: see above
    % folds: a Nxk matrix of ones and zeros, with N = length(y) and k the
    % number of cross-validation folds. folds(j,i) should be 1 if the j'th 
    % observation is to be included in the i'th fit set, and 0 if it should 
    % be included in the i'th validation. <a href="matlab: help getcvfolds">getcvfolds</a> retrieves a matrix 
    % suitable for this purpose.
    %
    % varargin parameters 
    % (entered in pairs, ie, cvglmfitsparseprior(y,X,U,5,'modeltype','ls')
    % --------------------------------------------------------------------
    % modeltype: The GLM model type, a string indicating the combination of 
    %            a link and a distribution. Default: logistic.
    %             logistic: logistic regression, where y = +- 1,
    %                       g^-1 is the logistic function*2-1, and the
    %                       distribution is the Bernouilli
    %             logisticr: logistic regression for n repeats, where y = 0..n 
    %                       is the number of successes,
    %                       g^-1 is the logistic function*n, and the
    %                       distribution is the binomial. Requires extra
    %                       parameter (see modelextra)
    %             exppoisson: Poisson regression, where y = integers
    %                       g^-1 is the exponential function, and the
    %                       distribution is the Poisson. Suitable for count
    %                       data.
    %             ls: Least-Squares, where y = real,
    %                 g^-1 is the identity function, and the distribution
    %                 is the normal. 
    % modelextra: Some model-type specific parameter(s).
    %             logisticr: a single integer, n, equal to the number of
    %             repeats. 
    % cvdeviancedelta: The minimum increase in cross-validated deviance,
    %                  w/r to the minimum of the cv deviance, for the
    %                  algorithm to exit cross-validation and enter the
    %                  final optimization. Default: 10.
    % minlambda : The minimum lambda as a fraction of the maximal lambda
    %             to run the cross-validation to in case the cv deviance
    %             condition is never reached. Default: 1e-3
    % cvtol : The tolerance of the optimization when calling
    %         glmfitsparseprior on the folds. Default: 1e-2
    % tol : The tolerance of the optimization when calling
    %       glmfitsparseprior on the full data. Default: 1e-3
    % 
    % returns:
    % --------------------------------------------------------------------
    %  thefit: a struct with the optimal w and u, goodness of fit, cross-
    %  validated goodness of fit, etc.
    %
    % See also GLMFITSPARSEPRIOR

    %Parse params
    options = poptions(varargin,'modeltype','logistic','modelextra',[],'cvtol',1e-2,'tol',1e-2,'cvdeviancedelta',10,'minlambda',1e-3);
    mmv2struct(options);
    
    kfold = size(folds,2);
    preds = cell(kfold,1);
    lambdas = cell(kfold,1);
        
    valsets = [];
    
    %Fit across sets
    lambdabounds = exp((0.05:0.05:1)*log(minlambda));
    fprintf('\nStarting cross validation\n\n');
    fprintf('                                      CV deviance\n');
    fprintf('lambda/lambda_max    ');
    
    for ii = 1:kfold
        fprintf('fold %d   ', ii);
    end
    
    fprintf('    total\n');
    
    %Compute minimum deviance
    for ii = 1:kfold
        fitset = ~folds(:,ii);
        switch modeltype
            case 'logistic'
                fmin = 0;
            case 'logisticr'
                phi = y(fitset)/modelextra;
                fmin = -sum(y(fitset).*log(phi+eps)+(modelextra-y(fitset)).*log(1-phi+eps));
            case 'exppoisson'
                fmin = sum(y(fitset) - y(fitset).*log(y(fitset)+eps));
            case 'ls'
                fmin = 0;
        end
        fmins(ii) = fmin;
    end
    
    %Fit cv sets
    for jj = 1:length(lambdabounds)
        lmax = lambdabounds(jj);
        fprintf('     %.3f         ',lmax);
        for ii = 1:kfold
            
            if jj == 1
                foldfits{ii} = [];
                cvlogliks{ii} = [];
                lambdas{ii} = [];
            end

            foldfit = glmfitsparseprior(y(folds(:,ii)),X(folds(:,ii),:),U(folds(:,ii),:),lmax,'modeltype',modeltype,'modelextra',modelextra,'tol',cvtol,'oldfit',foldfits{ii},'silent',1);
            
            foldfits{ii} = foldfit;
            
            startidx = length(lambdas{ii}) + 1;
            
            predfold = X(~folds(:,ii),:)*foldfit.ws(:,startidx:end) + U(~folds(:,ii),:)*foldfit.us(:,startidx:end);

            switch modeltype
                case 'logistic'
                    phi = 1./(1+exp(-predfold.*(y(~folds(:,ii))*ones(1,size(predfold,2)))));
                    cvloglik = -sum(log(phi),1);
                case 'logisticr'
                    phi = 1./(1+exp(-predfold));
                    cvloglik = -sum((y(~folds(:,ii))*ones(1,size(predfold,2))).*log(phi)+(modelextra-(y(~folds(:,ii))*ones(1,size(predfold,2)))).*log(1-phi),1);
                case 'exppoisson'
                    cvloglik = sum(exp(predfold) - (y(~folds(:,ii))*ones(1,size(predfold,2))).*predfold,1);
                case 'ls'
                    cvloglik = 1/2*sum((predfold - y(~folds(:,ii))*ones(1,size(predfold,2))).^2,1);
            end
            
            cvloglik = cvloglik - fmins(ii);
            
            fprintf('%8.1f ',cvloglik(end)*2);
                        
            cvlogliks{ii} = [cvlogliks{ii},cvloglik];
            
            if nnz(abs(preds{ii})>100) > 0
                disp('WTF');
            end

            lambdas{ii} = foldfit.lambdas(:)/max(foldfit.lambdas(:));
        end
        
        [interpcvlogliks interplambdas] = interpolatelogliks(cvlogliks,lambdas);
        
        cvdeviances = 2*interpcvlogliks;
        interpcvlogliks = sum(interpcvlogliks,2);
        
        fprintf('    %8.2f\n',interpcvlogliks(end)*2);
        
        [minl idx] = min(interpcvlogliks);
        blambda = interplambdas(idx);
        if 2*(interpcvlogliks(end) - min(interpcvlogliks)) > cvdeviancedelta
            if (blambda-min(interplambdas))/blambda > 0.2
                break;
            end
        end
    end
    
    fprintf('\nCross-validation done.\nBest lambda/lambda_max: %.3f\nLambda range: %.3f..1\n\nStarting main fit\n\n',...
           blambda,min(interplambdas));
    
    fullfit = glmfitsparseprior(y,X,U,min(interplambdas),'modeltype',modeltype,'modelextra',modelextra,'tol',tol);
    
    %Find the lambda closest to the optimal lambda
    [discard idx] = min(abs(fullfit.lambdas/max(fullfit.lambdas)-blambda));
    
    %Select that one as best
    fullfit.w = fullfit.ws(:,idx);
    fullfit.u = fullfit.us(:,idx);
    fullfit.deviance = fullfit.deviances(idx);
    fullfit.df = (nnz(fullfit.w) + nnz(fullfit.u));
    fullfit.aic = fullfit.deviance+fullfit.df*2;
    fullfit.cvlambdas = interplambdas*max(fullfit.lambdas);
    fullfit.cvdeviances = cvdeviances;
    fullfit.cvdeviance = min(interpcvlogliks)*2;

    if(nnz(interpcvlogliks==Inf)>0)
        disp('WTF');
    end
end

function [alllogliks alllambdas] = interpolatelogliks(cvlogliks,lambdas)
    alllambdas = reverse(unique(min(max(cell2mat(lambdas),max(cellfun(@min,lambdas))),min(cellfun(@max,lambdas)))));
    alllogliks = zeros(length(alllambdas),length(cvlogliks));
    
    for ii = 1:length(cvlogliks)
        alllogliks(:,ii) = interp1(lambdas{ii},cvlogliks{ii},alllambdas);
    end
    
end