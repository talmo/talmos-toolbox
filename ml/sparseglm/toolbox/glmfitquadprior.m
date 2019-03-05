function thefit = glmfitquadprior(y,X,U,qf,varargin)
    %[thefit] = glmfitquadprior(y,X,U,qf,varargin)
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
    % Exponential Poisson (LNP) model, suitable for neural data)
    %
    % Where there exists a quadratic prior on w of the form:
    %
    % p(w) = 1/2*lambda*w'*qf*w
    %
    % Algorithm: A simple convex optimization done through fminunc
    % (trust-region Newton)
    %
    % varargin: (entered in pairs)
    %  link: The GLM model type, currently logistic (default) or exppoisson
    %  w0: [wstart;ustart]: if left blank will be initialized to random
    %  values
    % 
    % returns:
    %  thefit: a struct with the optimal w and u, goodness of fit, etc.
    
    options = poptions(varargin,...
            'link','logistic',...
            'w0',randn(size(X,2)+size(U,2),1)/(size(X,2)+size(U,2)),...
            'getdf',0);
                       
    mmv2struct(options);
    wrange = 1:size(X,2);
    urange = (size(X,2)+1):(size(X,2)+size(U,2));
    
    X = [X,U];
    
    w = w0; %Start with a good guess
    
    switch link
        case 'logistic'
            errorfunc = @(w) errorfunclogistic(w,y,X,wrange,urange,qf);
        case 'exppoisson'
            errorfunc = @(w) errorfuncexppoisson(w,y,X,wrange,urange,qf);
    end
    
    %Optimize w
    options = optimset('Display','Off','GradObj','On','LargeScale','Off','DerivativeCheck','Off','TolFun',1e-3);
    w = fminunc(errorfunc,w0,options);
    
    switch link
        case 'logistic'
            yXwUu = y.*(X*w);
            phi = 1./(1+exp(-yXwUu));
            loglik = -sum(log(phi));
            logposterior = loglik + 1/2*sum(w(wrange)'*qf*w(wrange));
        case 'exppoisson'
            XwUu = X*w;
            loglik = sum(exp(XwUu) - y.*XwUu);
            logposterior = loglik + 1/2*sum(w(wrange)'*qf*w(wrange));
    end
    
    thefit.u = w(urange);
    thefit.w = w(wrange);
    thefit.deviance = 2*loglik;
    
    if getdf
        [f g Hp Hf] = errorfunc(w);
        %Brute force == stupid. Don't laugh
        thefit.df = size(U,2) + trace(inv(Hf)*Hp);
        thefit.aic = thefit.deviance+2*thefit.df;
    end
end


function [f g Hp Hf] = errorfunclogistic(w,y,X,wrange,urange,qf)
    yXwUu = y.*(X*w);
    phi = 1./(1+exp(-yXwUu));
    qfw = qf*w(wrange);
    f = -sum(log(phi+1e-12)) + 1/2*sum(w(wrange)'*qfw);

    g = -((((1-phi)).*y)'*X)' + [qfw;zeros(length(urange),1)];
    
    if nargout > 2
        Hp = mpow((sqrt(phi.*(1-phi))*ones(1,length(wrange))).*X(:,wrange));
        Hf = Hp + qf;
    end
end

function [f g] = errorfuncexppoisson(w,y,X,wrange,urange,qf)
    XwUu = X*w;
    qfw = qf*w(wrange);
    f = sum(exp(XwUu) - y.*XwUu) + 1/2*sum(w(wrange)'*qfw);

    g = X'*(exp(XwUu) - y) + [qfw;zeros(length(urange),1)];
end

function X = mpow(X)
    X = X'*X;
end