function [thenorm] = getBasisMatrix(basis,width,height)
    %Create normalization constants in a certain basis
    str = sprintf('%s_%d_%d',basis,width,height);
    global basismat;
    if(isfield(basismat,str))
        thenorm = basismat.(str);
        return;
    end
    switch basis
        case 'lpyr'
            thenorm = createlpyrmat(width,height);
        case 'sp0Filters'
            thenorm = createspyrmat('sp0Filters',width,height);
        case 'sp1Filters'
            thenorm = createspyrmat('sp1Filters',width,height);
        case 'sp3Filters'
            thenorm = createspyrmat('sp3Filters',width,height);
        case 'sp5Filters'
            thenorm = createspyrmat('sp5Filters',width,height);
    end
    
    basismat.(str) = thenorm;
end

function [themat] = createlpyrmat(width,height)
    [s,c] = buildLpyr(zeros(height,width),'auto');
    len = length(s);
    themat = zeros(width*height,len);
    for ii = 1:len
        targetv = zeros(len,1);
        targetv(ii) = 1;
        resultv = reconLpyr(targetv,c);
        themat(:,ii) = resultv(:);
    end
end

function [themat] = createspyrmat(filt,width,height)
    [s,c] = buildSpyr(zeros(height,width),'auto',filt);
    len = length(s);
    themat = zeros(width*height,len);
    for ii = 1:len
        targetv = zeros(len,1);
        targetv(ii) = 1;
        resultv = reconSpyr(targetv,c,filt);
        themat(:,ii) = resultv(:);
    end
end