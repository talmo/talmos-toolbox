function thefit = glmfitsparseprior(y,X,U,stopcrit,varargin)
    %[thefit] = glmfitsparseprior(y,X,U,stopcrit,varargin)
    %
    % Optimizes a GLM model through MAP where the internal variable is generated through:
    % eta = X*w + U*u
    %
    % And E(y) = mu = g^-1(eta), where E is the expected value and g is the modeltype
    % function and:
    %
    % p(y|mu) = some exponential family distribution
    %
    % Where there exists a sparse (Laplacian) prior on w of the form:
    %
    % p(w) = exp(-lambda*||w||_1),    p(u) = uniform everywhere (no prior)
    %
    % From lambda = lambda_max descending to lambda = lambda_max*stopcrit
    % using a fixed point continuation algorithm
    % 
    %
    % varargin parameters 
    % (entered in pairs, ie, glmfitsparseprior(y,X,U,1e-3,'modeltype','ls')
    % --------------------------------------------------------------------
    % modeltype: The GLM model type, a string indicating the combination of 
    %            a modeltype and a distribution. Default: logistic.
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
    % tol : The tolerance of the optimization, as the decrease in L/lambda +
    %       sum(abs(w)) below which the optimization is deemed to have
    %       converged. Default: 1e-3
    % 
    % returns:
    % --------------------------------------------------------------------
    %  thefit: a struct with the entire path of ws, us, lambdas, computed
    %  deviances and corrected AIC deviances, etc.
    %
    %  maxdeviance refers to the deviance of the GLM with only u
    %  parameters. r^2-like values can be obtained by 1 -
    %  deviance/maxdeviance
    %
    options = poptions(varargin,'modeltype','logistic','modelextra',[],'tol',1e-2,'oldfit',[],'silent',0);
    mmv2struct(options);
    
    maxgamm = 0.99;
    mingamm = 0.90;
    
    niters = 1;
    
    if ~isempty(oldfit)
        %Load an old fit and restart the optimization
        w = oldfit.ws(:,end);
        ws = oldfit.ws;
        u = oldfit.us(:,end);
        us = oldfit.us;
        ii = 1 + size(oldfit.ws,2);
        tau0 = oldfit.restartinfo.tau0;
        logliks = oldfit.deviances;
        dfs = oldfit.restartinfo.dfs;
        
        lambdas = oldfit.lambdas;
        Uu = U*u;
        eta = oldfit.restartinfo.eta;
        maxdeviance = oldfit.restartinfo.maxdeviance;
        Xw = eta - Uu;
        
        lambda = oldfit.lambdas(end);
        fmin = oldfit.restartinfo.fmin;
        f = (oldfit.deviances(end)+2*fmin)/lambda/2 + sum(abs(w));
        ll = (oldfit.deviances(end)+2*fmin)/2;
        lambdamax = max(lambdas);
        
    else
        %Start a new fit
        w = zeros(size(X,2),1);
        u = zeros(size(U,2),1);
        
        tau0 = gettau0(X,y,modeltype,modelextra);
        
        %Calculate max lambda
        Xw = X*w;
        [u f] = uopt(u,Xw,U,y,modeltype,modelextra,1e9);
        maxdeviance = f*2;
        Uu = U*u;
        eta = X*w+Uu;
        
        ll = calcf(eta,y,modeltype,modelextra);
        g = calcg(eta,X,y,modeltype,modelextra);

        lambdamax = max(abs(g))*0.999;
        lambda = lambdamax;

        %Preassign stuff
        lambdas = [];
        ws = [];
        us = [];
        logliks = [];
        dfs = [];
        
        fmin = calcfmin(y,modeltype,modelextra);
        
        ii = 1;
    end
    
    lambdamin = lambdamax*stopcrit;
    
    tausuggest = tau0/2;
    
    %Main exterior loop
    while lambda > lambdamin
        
        %Assign stuff in batches of 50
        if mod(ii,50) == 1
            lambdas = [lambdas;zeros(50,1)];
            ws = [ws,zeros(length(w),50)];
            us = [us,zeros(length(u),50)];
            logliks = [logliks;zeros(50,1)];
            dfs = [dfs;zeros(50,1)];
        end
        
        if ii > 1
            g = calcg(eta,X,y,modeltype,modelextra);
        end
        
        %Find a good lambda based on heuristics presented in paper
        if ii >= 2
            lambdasug = max(abs(g(w==0)));
            
            if isempty(lambdasug)
                %Model full
                lambdasug = lambdamax;
            end
            %lambdasug/(lambda)
            lambda = max(min(lambdasug,lambda*maxgamm),lambda*mingamm)*.999;
        end

        lambdas(ii) = lambda;
        
        f = ll/lambda+sum(abs(w));
        f_before = f + 2*tol;
                
        jj = 1;
        while lambda*f < lambda*f_before-tol
            f_before = f;
            
            if jj > 1
                g = calcg(eta,X,y,modeltype,modelextra); %g is fresh to start with
            end

            [w eta f] = findbestshrink(g,w,X,lambda,tausuggest,y,Uu,Xw,modeltype,modelextra,ll);
            ll = (f - sum(abs(w)))*lambda;
            Xw = eta-Uu;
            niters = niters + 1;
            jj = jj + 1;
            
        end
       
        Xw = eta-Uu;
                
        u = uopt(u,Xw,U,y,modeltype,modelextra,ll);
        
        eta = Xw + U*u;
        ll = calcf(eta,y,modeltype,modelextra);
        
        Uu = U*u;
        eta = Xw + Uu;
        
        if mod(ii,10)==0
            if ~silent
                fprintf('Iteration %3d, lambda = %4.1f\n',ii,lambda);
            end
            %Also, recalc Xw to avoid accumulation of roundoff errors
            Xwb = Xw;
            Xw = X*sparse(w);
            dXw = norm(Xwb-Xw);
            if dXw >= 1e-10
                warning('glmfitsparseprior:cumerror','Cumulative error in Xw starting to become significant');
            end
            eta = Xw+Uu;
        end
                
        ws(:,ii) = w;
        us(:,ii) = u;
        
        logliks(ii) = ll;
        df = nnz(w)+nnz(u);
        dfs(ii) = df;
        
        ii = ii+1;
        
    end
    
    nouter = ii - 1;
    
    thefit.deviances = (logliks(1:nouter)-fmin)*2;
    thefit.deviancesaic = (logliks(1:nouter)-fmin+dfs(1:nouter))*2;
    thefit.lambdas = lambdas(1:nouter);
    thefit.ws = sparse(ws(:,1:nouter));
    thefit.us = us(:,1:nouter);
    thefit.restartinfo = struct('tau0',tau0,'eta',eta,'dfs',dfs,'fmin',fmin,'maxdeviance',maxdeviance);
    thefit.maxdeviance = maxdeviance;
    
    if ~silent
        fprintf('\nDone. Total number of inner iterations: %3d\n\n',niters-1);
    end
end

%Get tau0, the maximum step size for which the optimization is sure to
%terminate /2
function tau0 = gettau0(X,y,modeltype,modelextra)
    opts.disp = 0;
    switch modeltype
        case 'logistic'
            maxeig = eigs(X'*X,1,'LM',opts);
            tau0 = 4/maxeig;
        case 'logisticr'
            maxeig = modelextra*eigs(X'*X,1,'LM',opts);
            tau0 = 4/maxeig;
        case 'exppoisson'
            maxeig = eigs(mpow((sqrt(y)*ones(1,size(X,2))).*X),1,'LM',opts);
            tau0 = 1/maxeig;
        case 'ls'
            maxeig = eigs(X'*X,1,'LM',opts);
            tau0 = 1/maxeig;
    end
end

%Compute L the negative log-likelihood
function f = calcf(eta,y,modeltype,modelextra)
    switch modeltype
        case 'logistic'
            f = -sum(log(1./(1+exp(-eta.*y))));
        case 'logisticr'
            phi = 1./(1+exp(-eta));
            f = -sum(y.*log(phi)+(modelextra-y).*log(1-phi));
        case 'exppoisson'
            f = sum(exp(eta) - y.*eta);
        case 'ls'
            f = 1/2*sum((eta - y).^2);
    end
end

%Compute L, the negative log-likelihood, when mu = y
function f = calcfmin(y,modeltype,modelextra)
    switch modeltype
        case 'logistic'
            f = 0;
        case 'logisticr'
            phi = y/modelextra;
            f = -sum(y.*log(phi+eps)+(modelextra-y).*log(1-phi+eps));
        case 'exppoisson'
            f = sum(y - y.*log(y+eps));
        case 'ls'
            f = 0;
    end
end

%Compute g = dL/dw, the derivative of the negative loglikelihood w/r to the
%weights, and possibly the Hessian H = d^2L/dw^2 and the negative
%log-likelihood L
function [g H f] = calcg(eta,X,y,modeltype,modelextra)
    switch modeltype
        case 'logistic'
            phi = 1./(1+exp(-eta.*y));
            g = -((((1-phi)).*y)'*X)';
            if nargout > 1
                if size(X,2) == 1
                    H = (X.^2)'*((1-phi).*phi);
                else
                    H = mpow(sqrt((1-phi).*phi)*ones(1,size(X,2)).*X);
                end
            end
            if nargout > 2
                f = -sum(log(phi));
            end
        case 'logisticr'
            phi = 1./(1+exp(-eta));
            g = -((y-modelextra*phi)'*X)';
            if nargout > 1
                if size(X,2) == 1
                    H = modelextra*(X.^2)'*((1-phi).*phi);
                else
                    H = modelextra*mpow(sqrt((1-phi).*phi)*ones(1,size(X,2)).*X);
                end
            end
            if nargout > 2
                f = -sum(y.*log(phi)+(modelextra-y).*log(1-phi));
            end
        case 'exppoisson'
            expeta = exp(eta);
            g = X'*(expeta - y);
            if nargout > 1
                if size(X,2) == 1
                    H = X'*(expeta.*X);
                else
                    H = mpow(sqrt(expeta)*ones(1,size(X,2)).*X);
                end
            end
            if nargout > 2
                f = sum(exp(eta) - y.*eta);
            end
        case 'ls'
            g = X'*(eta-y);
            if nargout > 1
                H = X'*X;
            end
            if nargout > 2
                f = 1/2*sum((eta - y).^2);
            end
    end
end

%Compute g = dL/deta, the derivative of the negative loglikelihood w/r to 
%eta = X*w, as well as H = d^2L/deta^2, evaluated at eta
function [g H] = calcetagH(eta,y,modeltype,modelextra)
    switch modeltype
        case 'logistic'
            phi = 1./(1+exp(-eta.*y));
            g = -(1-phi).*y;
            H = phi.*(1-phi);
        case 'logisticr'
            phi = 1./(1+exp(-eta));
            g = -(y-modelextra*phi);
            H = modelextra*phi.*(1-phi);
        case 'exppoisson'
            expeta = exp(eta);
            g = expeta-y;
            H = expeta;
        case 'ls'
            g = eta-y;
            H = ones(size(y));
    end
end

function [w eta f] = findbestshrink(g,w0,X,lambda,tau,y,eta0,Xw0,modeltype,modelextra,feta)
    signw0 = sign(w0-eps*g);
    taus = w0./(g+lambda*signw0);
    taus = taus.*(taus>0);
    wpos = -g.*(signw0) > lambda;
    
    w00 = w0;
    g00 = g;
    %Isolate the weights which can be non-zero for tau > 0
    widx = wpos | taus > 0;
    
    taupool = taus(widx);
    taupool = taupool(taupool>0);
    taupool = [0;sort(taupool);Inf];

    %Construct Xw = Xw0 + tau*dXw + remainder
    %Xw0 = X*sparse(w0);
    deta = X*sparse((-g-lambda*signw0).*widx);
    
    %Compute quadratic approximation to error starting from Xw0
    %feta0 = feta;
    feta0 = feta;
    [geta Heta] = calcetagH(eta0+Xw0,y,modeltype,modelextra);

    feta = feta/lambda;
    
    tau0 = tau;
    tau = 0;
    ii = 1;
    
    fs = zeros(size(taupool));
    w = signw0.*max(signw0.*(w0-eps*(g+lambda*signw0)),0);
    fs(1) = feta + sum(abs(w));
    
    etacum = 0;
    done = 0;
    
    while ~done
        
        taur = tau + 10*eps;
        w = signw0.*max(signw0.*(w0-taur*(g+lambda*signw0)),0);
        dpdw = sum(-(g.*signw0+lambda).*(w~=0));
        eta1 = geta'*deta/lambda;
        Hetadeta = Heta.*deta;
        eta2 = deta'*Hetadeta/lambda;
        
        tausugg = (-eta1 - dpdw)/eta2;
        
        if ii+1 > length(taupool)
            tau = tau0;
            break;
        end
        
        taumax = taupool(ii+1)-taupool(ii);
        
        if tausugg > 0 && tausugg < taumax
            %Found it
            tau = taupool(ii) + tausugg;
            etacum = etacum + tausugg*deta;
            done = 1;
            w = signw0.*max(signw0.*(w0-tau*(g+lambda*signw0)),0);
            taupool(ii+1) = tau;
            fs(ii+1) = feta + tausugg*eta1 + 1/2*tausugg^2*eta2 +sum(abs(w));
            bestf = fs(ii+1);
        else
            
            tau = taupool(ii+1);
            idx = find(taus == tau);
            
            %Failure
            if isempty(idx) && tau ~= Inf
                tau = 0;
                done = 1;
            end
            
            feta = feta + taumax*eta1 + 1/2*taumax^2*eta2;
            geta = geta + taumax*Hetadeta;
            etacumold = etacum;
            etacum = etacum + taumax*deta;
            w = signw0.*max(signw0.*(w0-tau*(g+lambda*signw0)),0);
            fs(ii+1) = feta + sum(abs(w));
            
            if isnan(fs(ii+1)) || fs(ii+1) > fs(ii)
                done = 1;
                tau = taupool(ii);
                etacum = etacumold;
                bestf = fs(ii);
            end
            
            deta = deta + X(:,idx)*(g(idx)+lambda*sign(w0(idx)-eps*g(idx)));
            
        end
        %fs(ii+1) = fs(ii) + sum(abs(wold));
        ii = ii + 1;
    end
   
    w = shrink(w0-tau*g,tau*lambda);
    eta = eta0+Xw0+X*sparse(w-w0);

    f = 1/lambda*calcf(eta,y,modeltype,modelextra)+sum(abs(w));

    %abs(f-bestf)
    
    %Failure, revert to tau = tau0
    %Shouldn't happen but sometimes does when there are more regressors
    %than observations
    if f > fs(1) || tau == 0
        w = shrink(w00-tau0*g00,tau0*lambda);
        eta = eta0+X*sparse(w);
        f = 1/lambda*calcf(eta,y,modeltype,modelextra)+sum(abs(w));
    end
end

%{
%This alternative findbestshrink uses the suggested tau
%Slower except in best case scenarios (X'X == 1/tau*I)
function [w eta f] = findbestshrinknew(g,w0,X,lambda,tau,y,eta0,Xw0,modeltype,feta)
    w = shrink(w0-tau*g,tau*lambda);
    dw = (w-w0);
    dw = sparse(dw);
    eta = eta0 + Xw0 +X*dw;
    f = 1/lambda*calcf(eta,y,modeltype)+sum(abs(w));
end
%}

function [w] = shrink(w,eta)
    w = sign(w).*max(abs(w)-eta,0);
end

function [u f] = uopt(u,Xw,U,y,modeltype,modelextra,f)
    %Run three Newton iterations to fit u
    R = 1e-10*eye(length(u));
    f_before  = f+1e2;
    niter = 0;
    damping = 1;
    eta = Xw + U*u;
    while f - f_before < -1e-3
        f_before = f;
        [g H] = calcg(eta,U,y,modeltype,modelextra);

        uold = u;
        f = f_before + 2*1e-2;
        while f > f_before && damping > 1e-15
            damping = 0.1*damping;
            u = uold - damping*inv(H+R)*g;
            eta = Xw + U*u;
            f = calcf(eta,y,modeltype,modelextra);
        end

        niter = niter + 1;
    end
    %niter
end

function [X] = mpow(X)
    X = X'*X;
end
    