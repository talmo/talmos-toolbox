% MIRT2D_REGSOLVE  The function updates the position of B-spline control
% points based on the given gradient.
%
% Input
% X - a 3D array of positions of B-spline control points in a single 2D image
%     The 3rd dimension size is 2, it indicates the coordinate x and y
% T - a 3D array with gradient of the similarity measure at the B-spline
%     control points
%
% Output
% X - new coordinates of B-spline control points
% f - the value of the regularization term
% mode - a switch indicator, mode=1 if we simply want the value of the
%        regularization term without computation of the new positions
%
% Copyright (C) 2007-2010 Andriy Myronenko (myron@csee.ogi.edu)
% also see http://www.bme.ogi.edu/~myron/matlab/MIRT/
%
%     This file is part of the Medical Image Registration Toolbox (MIRT).

function [X,f]=mirt2D_regsolve(X,T,main,optim, mode)

if ~exist('mode','var'), mode=0; end;
% find the displacements, as the regularization is defined over the
% displacements of the B-spline control points
X=X-main.Xgrid;


if mode, % if we want simply compute the value of the regularization term
    dux=mirt_dctn(X(:,:,1));
    duy=mirt_dctn(X(:,:,2));
    
    f=0.5*main.lambda*sum(main.K(:).*(dux(:).^2+duy(:).^2));

else  
    %% Update the node positions
    % make step in the direction of the gradient
    X=X-T*optim.gamma;
    
    % solve the Laplace equation in 2D,
    % through DCT. Here main.K is the precomputed
    % matrix of the squared Laplacian eigenvalues
    diax=main.lambda*optim.gamma*main.K+1;
    dux=mirt_dctn(X(:,:,1))./diax;
    duy=mirt_dctn(X(:,:,2))./diax;
    f=0.5*main.lambda*sum(main.K(:).*(dux(:).^2+duy(:).^2));% compute the value of the regularization term
    dux=mirt_idctn(dux);
    duy=mirt_idctn(duy);
    
    % concatinate the new displacement poistions in 3D array and add
    % the offset (grid).
    X=cat(3,dux,duy)+main.Xgrid;
end