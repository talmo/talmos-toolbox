function [qf] = qfsmooth(numx,numy)
    %[qf] = qfsmooth(numx,numy)
    %Create a quadratic form for smoothness regularization, with D a
    %first-order partial derivative operator and qf = D'*D
    D = zeros((numx-1)*numy + (numy-1)*numx + 1,numx*numy);
    for jj = 1:numy
        for ii = 1:numx-1
            [xi yi] = meshgrid(1:numx,1:numy);
            dd = (xi == ii & yi == jj) - (xi == ii + 1 & yi == jj);
            D(ii + (jj-1)*(numx-1),:) = dd(:);
        end
    end
    
    for jj = 1:numy-1
        for ii = 1:numx
            [xi yi] = meshgrid(1:numx,1:numy);
            dd = (xi == ii & yi == jj) - (xi == ii & yi == jj + 1);
            D((numx -1)*numy + ii + (jj-1)*numx,:) = dd(:);
        end
    end
    
    %One must add a penalty for the mean, otherwise D2 has the 0 eigenvalue
    %and D2 is not positive definite
    %ie: 0*D2 = 0*v (v is the constant vector (1,1,1,...1)
    D(end,:) = 1/sqrt(numx*numy);
    
    qf = D'*D;