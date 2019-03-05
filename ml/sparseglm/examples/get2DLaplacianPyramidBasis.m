function [B] = get2DLaplacianPyramidBasis(width, height, levels, step, FWHM)
    %function [B] = get2DLaplacianPyramidBasis(width, height, levels, step,
    %FWHM)
    %
    %Get a 2d Laplacian pyramid basis matrix of given number of levels for 
    %images of size width x height. step indicates the spacing of levels (1
    %= regular Laplacian pyramid, 0.5 = Laplacian pyramid with
    %half-levels). FWHM is full width at half-max for the Gaussians at
    %level 1 (the finest level). 
    %
    %Differences from "standard LP implementation": this implementation is
    %designed to be more flexible such that the chosen basis functions can
    %be more tightly spaced or less decimated than usual. Level 1 is not
    %treated as a "residual" or "pixel" level: it uses Gaussians of the
    %specified FWHM. Gaussians center locations differ from the standard
    %implementation for levels 3 and up: they are set up such that they
    %avoid edges (for example, for a 17x17 image, the level three leftmost 
    %and topmost basis function is centered at (3,3), not (1,1). Basis
    %functions which touch edges are not distorted, simply cropped.
    B = [];
    [xi yi] = meshgrid(1:width,1:height);
    rg1 = xi(:);
    rg2 = yi(:);
    num = 1;
    for ii = 1:step:levels
        cens1 = (0:(width/(2^(ii-1))-1))*(2^(ii-1));
        cens2 = (0:(height/(2^(ii-1))-1))*(2^(ii-1));
        cens1 = floor((width-(max(cens1)-min(cens1)+1))/2+cens1)+1;
        cens2 = floor((height-(max(cens2)-min(cens2)+1))/2+cens2)+1;
        gwidth = 2^(ii-1)/2.35482*FWHM;
        if(length(cens1) <= 1 && length(cens2) <= 1)
            error('level parameter is too large: maximum is %d',ii-step);
        end
        B = [B,zeros(length(rg1),length(cens1))]; %Allocate memory in bulk
        for jj = 1:length(cens1)
            for kk = 1:length(cens2)
                v = exp(-((rg1-cens1(jj)).^2+(rg2-cens2(kk)).^2)/2/gwidth^2);
                B(:,num) = v/norm(v(:));
                num = num + 1;
            end
        end
    end
end