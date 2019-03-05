function [qf] = qfsmooth1D(numx)
    %[qf] = qfsmooth1D(numx)
    %Create a quadratic form for smoothness regularization based on
    %second-order derivative operator, for a one-dimensional signal
    D = zeros(numx+1,numx);
    for ii = 1:numx-2
        D(ii,ii:ii+2) = [-1 2 -1];
    end
    
    %One must add a penalty for the mean, otherwise D2 has the 0 eigenvalue
    %and D2 is not positive definite
    %ie: 0*D2 = 0*v (v is the constant vector (1,1,1,...1)
    D(end-2,:) = 1/sqrt(numx);
    D(end-1,[1]) = [1];
    D(end,[numx]) = [1];
    
    qf = D'*D;