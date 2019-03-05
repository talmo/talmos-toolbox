function [B] = get1DLaplacianPyramidBasis(width, levels, step, FWHM)
    %function [B] = get2DLaplacianPyramidBasis(length, height, levels, step,
    %FWHM)
    %
    %Get a 1d Laplacian pyramid basis matrix of given number of levels for 
    %vectors of given length. step indicates the spacing of levels (1
    %= regular Laplacian pyramid, 0.5 = Laplacian pyramid with
    %half-levels). FWHM is full width at half-max for the Gaussians at
    %level 1 (the finest level). 
    
    B = [];
    rg = 1:width;
    for ii = 1:step:levels
        cens = 2^(ii-2)+ (0:(width/(2^(ii-1))-1))*(2^(ii-1));
        %cens = 1:width;
        cens = floor((width-(max(cens)-min(cens)+1))/2+cens)+1;
        gwidth = 2^(ii-1)/2.35*FWHM;
        for jj = 1:length(cens)
            v = exp(-(rg-cens(jj)).^2/2/gwidth^2);
            %v = besseli(rg-cens(jj),gwidth*sqrt(2));
            B = [B;v/norm(v(:))];
        end
    end
    B = B';
end