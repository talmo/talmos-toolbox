function thefit = cvglmfitquadprior(y,X,U,qf,folds,varargin)
    %[thefit] = cvglmfitquadprior(X,U,y,A,kfold,varargin)
    %
    % Optimizes a GLM model through MAP where the internal variable is generated through:
    % v = X*w + U*u
    %
    % In the case where link = logistic, then each y = +- 1, and:
    % -log p(y|v) = -log(logistic(y*v)) (Logistic regression model, 
    % suitable for classification image data)
    % 
    % In the case where link = exppoisson, then each y is an integer >= 0, and 
    % -log p(y|v) = exp(v) - y*v (Poisson regression or Linear
    % Exponential Regression model, sutiable for neural data)
    %
    % Where there exists a quadratic prior on w of the form:
    %
    % p(w) = lambda*w'*qf*w
    %
    % The optimization first selects the optimal lambda based on kfold
    % cross-validation and refits the whole model based on the optimal
    % lambda
    %
    % varargin: (entered in pairs, ie, 'lambdas', (10.^(1:0.5:4))'
    %  lambdas: the lambdas considered for cross-validation purposes
    %  link: The GLM model type, currently logistic (default) or exppoisson
    % 
    % returns:
    %  thefit: a struct with the optimal w and u, goodness of fit, cross-
    %  validated goodness of fit, etc.
    
    options = poptions(varargin,'lambdas',10.^(-3:0.5:3)','link','logistic');
    mmv2struct(options);
    
    lambdas = lambdas(:);
    
    predsw = [];
    kfold = size(folds,2);
    
    cvlogliks = zeros(kfold,length(lambdas));
    
    for ii = 1:kfold
        fprintf('Fitting fold %d\n\n',ii);
        fitset = folds(:,ii);
        valset = ~fitset;
        
        w0 = randn(size(X,2)+size(U,2),1);
        w0 = w0/length(w0);
        
        for jj = 1:length(lambdas)
            fprintf('lambda = %.2e\n',lambdas(jj));
            thefit = glmfitquadprior(y(fitset),X(fitset,:),U(fitset,:),qf*lambdas(jj),'w0',w0,'link',link);
            w0 = [thefit.w;thefit.u];
            
            switch link
                case 'logistic'
                    yXwUu = y(valset).*([X(valset,:),U(valset,:)]*[thefit.w;thefit.u]);
                    cvloglik = -sum(log(1./(1+exp(-yXwUu))));
                case 'exppoisson'
                    XwUu = [X(valset,:),U(valset,:)]*[thefit.w;thefit.u];
                    cvloglik = (sum(exp(XwUu) - y(valset).*XwUu) - sum(mean(y(fitset)) - y(valset).*log(mean(y(fitset)))));
            end

            cvlogliks(ii,jj) = cvloglik;
        end
        fprintf('\n');
    end
    cvlogliks = sum(cvlogliks,1);
    
    [cvloglik bestlambdaidx] = min(cvlogliks);
    lambda = lambdas(bestlambdaidx);
    
    thefit = glmfitquadprior(y,X,U,qf*lambda,'link',link,'getdf',1);
    
    thefit.cvdeviance = cvloglik*2;
    thefit.cvdeviances = 2*cvlogliks';
    thefit.lambdas = lambdas;
end
